import 'dart:convert';
import 'dart:typed_data';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit/solana/solana_web3/solana_web3.dart' as solana;
import 'package:reown_appkit/solana/solana_web3/programs.dart' as programs;

/// SPL Token Service - Handles proper SPL token creation
class SplTokenService {
  final String TOKEN_PROGRAM_ID = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA';
  final String ASSOCIATED_TOKEN_PROGRAM_ID = 'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL';
  final String TOKEN_METADATA_PROGRAM_ID = 'metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s';

  Future<solana.Transaction> createToken({
    required solana.Connection connection,
    required solana.Pubkey ownerPubkey,
    required String name,
    required String symbol,
    required solana.Keypair mintKeypair, // NEW: pass mint keypair
    int decimals = 9,
    BigInt? initialSupply, // optional
  }) async {
    final blockhash = await connection.getLatestBlockhash();

    final List<solana.TransactionInstruction> instructions = [];

    // 1. Create the Mint account
    final rentExemption = await connection.getMinimumBalanceForRentExemption(82); // 82 bytes for Mint account

    instructions.add(
      programs.SystemProgram.createAccount(
        fromPubkey: ownerPubkey,
        newAccountPubkey: mintKeypair.pubkey,
        lamports: BigInt.from(rentExemption),
        space: BigInt.from(82),
        programId: solana.Pubkey.fromBase58(TOKEN_PROGRAM_ID),
      ),
    );

    // 2. Initialize the Mint
    instructions.add(
      programs.TokenProgram.initializeMint(
        mint: mintKeypair.pubkey,
        decimals: decimals,
        mintAuthority: ownerPubkey,
        freezeAuthority: ownerPubkey,
      ),
    );

    final List<List<int>> seeds = [
      ownerPubkey.toBytes(),           // Owner wallet address
      solana.Pubkey.fromBase58(TOKEN_PROGRAM_ID).toBytes(), // Token Program ID
      mintKeypair.pubkey.toBytes(),    // Mint address
    ];

    final associatedTokenAddress = await solana.Pubkey.findProgramAddress(
      [
        ownerPubkey.toBytes(),
        solana.Pubkey.fromBase58(TOKEN_PROGRAM_ID).toBytes(),
        mintKeypair.pubkey.toBytes(),
      ],
      solana.Pubkey.fromBase58(ASSOCIATED_TOKEN_PROGRAM_ID),
    );

    instructions.add(
      solana.TransactionInstruction(
        programId: solana.Pubkey.fromBase58(ASSOCIATED_TOKEN_PROGRAM_ID),
        keys: [
          solana.AccountMeta(ownerPubkey, isSigner: true, isWritable: true),
          solana.AccountMeta(associatedTokenAddress.pubkey, isSigner: false, isWritable: true),
          solana.AccountMeta(ownerPubkey, isSigner: false, isWritable: false),
          solana.AccountMeta(mintKeypair.pubkey, isSigner: false, isWritable: false),
          solana.AccountMeta(programs.SystemProgram.programId, isSigner: false, isWritable: false),
          solana.AccountMeta(solana.Pubkey.fromBase58(TOKEN_PROGRAM_ID), isSigner: false, isWritable: false),
          solana.AccountMeta(solana.Pubkey.fromBase58('SysvarRent111111111111111111111111111111111'), isSigner: false, isWritable: false),
        ],
        data: Uint8List(0),
      ),
    );

    if (initialSupply != null && initialSupply > BigInt.zero) {
      instructions.add(
        programs.TokenProgram.mintTo(
          mint: mintKeypair.pubkey,
          account: associatedTokenAddress.pubkey,
          mintAuthority: ownerPubkey,
          amount: initialSupply,
        ),
      );
    }

    // 5. Create Token Metadata
    final metadataPda = await solana.Pubkey.findProgramAddress(
      [
        utf8.encode('metadata'),
        solana.Pubkey.fromBase58(TOKEN_METADATA_PROGRAM_ID).toBytes(),
        mintKeypair.pubkey.toBytes(),
      ],
      solana.Pubkey.fromBase58(TOKEN_METADATA_PROGRAM_ID),
    );

    // Build metadata data
    final nameFixed = name; // Metaplex name max 32 chars
    final symbolFixed = symbol; // Metaplex symbol max 10 chars

    final uriFixed = 'https://worthy-swine-mutual.ngrok-free.app/api/core/token.json';

    // Build Metadata Instruction
    instructions.add(
      solana.TransactionInstruction(
        programId: solana.Pubkey.fromBase58(TOKEN_METADATA_PROGRAM_ID),
        keys: [
          solana.AccountMeta(metadataPda.pubkey, isSigner: false, isWritable: true),
          solana.AccountMeta(mintKeypair.pubkey, isSigner: false, isWritable: false),
          solana.AccountMeta(ownerPubkey, isSigner: true, isWritable: false),
          solana.AccountMeta(ownerPubkey, isSigner: true, isWritable: false),
          solana.AccountMeta(programs.SystemProgram.programId, isSigner: false, isWritable: false),
          solana.AccountMeta(solana.Pubkey.fromBase58('SysvarRent111111111111111111111111111111111'), isSigner: false, isWritable: false),
        ],
        data: _buildCreateMetadataV3InstructionData(
          nameFixed,
          symbolFixed,
          uriFixed,
        ),
      ),
    );

    // 6. Build the transaction
    final transaction = solana.Transaction.v0(
      payer: ownerPubkey,
      recentBlockhash: blockhash.blockhash,
      instructions: instructions,
    );
    return transaction;
  }
}
Uint8List _buildCreateMetadataV3InstructionData(
    String name,
    String symbol,
    String uri,
    ) {
  final buffer = BytesBuilder();

  buffer.addByte(33); // Instruction: CreateMetadataAccountV3 (discriminator 0)

  // 1. DataV2 struct starts
  buffer.add(_encodeRustString(name));     // name (string, Rust format)
  buffer.add(_encodeRustString(symbol));   // symbol (string, Rust format)
  buffer.add(_encodeRustString(uri));      // uri (string, Rust format)

  buffer.add(_u16le(0)); // sellerFeeBasisPoints = 0 (0% royalty)

  buffer.addByte(0); // creators: None
  buffer.addByte(0); // collection: None
  buffer.addByte(0); // uses: None
  // 1. DataV2 struct ends

  buffer.addByte(1); // isMutable = true

  buffer.addByte(0); // collectionDetails: None (new field added in v3)

  return buffer.toBytes();
}

Uint8List _encodeRustString(String value) {
  final bytes = utf8.encode(value);
  final length = _u32le(bytes.length);
  return Uint8List.fromList([...length, ...bytes]);
}

Uint8List _u16le(int value) {
  final bytes = ByteData(2);
  bytes.setUint16(0, value, Endian.little);
  return bytes.buffer.asUint8List();
}

Uint8List _u32le(int value) {
  final bytes = ByteData(4);
  bytes.setUint32(0, value, Endian.little);
  return bytes.buffer.asUint8List();
}

