# EOS Framework

This is a framework for push transaction of eos.

1. Use this method to get the bytes for signature.
+ (NSData *)getBytesForSignature:(NSData *)chainId andParams:(NSDictionary *)paramsDic andCapacity:(int)capacity;

2. Then get the string of signature with the private key.
+ (NSString *)initWithbytesForSignature:(NSData *)bytesForSignature privateKey:(int8_t *)privateKey;

# For example

NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];

NSString *signatureStr = [EosSignature initWithbytesForSignature:d privateKey:private_key];

NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
