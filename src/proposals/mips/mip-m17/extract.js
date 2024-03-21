const { toChecksumAddress } = require('ethereumjs-util');

const inputText = `
3). Liquidate bad mFRAX debt for user: 0xe0b2026e3db1606ef0beb764ccdf7b3cee30db4a
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000e0b2026e3db1606ef0beb764ccdf7b3cee30db4a


4). Liquidate bad mFRAX debt for user: 0xccb8e090fe070945cc0131a075b6e1ea8f208812
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000ccb8e090fe070945cc0131a075b6e1ea8f208812


5). Liquidate bad mFRAX debt for user: 0x7ecf0bf3d94dce4838d57b63dc96d6ddc2cc63e7
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000007ecf0bf3d94dce4838d57b63dc96d6ddc2cc63e7


6). Liquidate bad mFRAX debt for user: 0x6a67a0e5265730952ed7dd648aed357c7444999e
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000006a67a0e5265730952ed7dd648aed357c7444999e


7). Liquidate bad mFRAX debt for user: 0xaaddc55883b7df9944d54c20f2822f476673cbc0
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000aaddc55883b7df9944d54c20f2822f476673cbc0


8). Liquidate bad mFRAX debt for user: 0x7c976f00e84db0b44f945fc6d7fad34b43150a1a
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000007c976f00e84db0b44f945fc6d7fad34b43150a1a


9). Liquidate bad mFRAX debt for user: 0x4f5ef03e870332a1b42453bbf57b8a041e89efe8
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000004f5ef03e870332a1b42453bbf57b8a041e89efe8


10). Liquidate bad mFRAX debt for user: 0xa89da48796bb808cb9af3637ff7ab436f968c7d5
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000a89da48796bb808cb9af3637ff7ab436f968c7d5


11). Liquidate bad mFRAX debt for user: 0x54dc6782d6fc5fc05f8486d365186ff25cc44ba7
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000054dc6782d6fc5fc05f8486d365186ff25cc44ba7


12). Liquidate bad mFRAX debt for user: 0x395ef2d7a5d499b62ac479064b7eaa51ae823a22
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000395ef2d7a5d499b62ac479064b7eaa51ae823a22


13). Liquidate bad mFRAX debt for user: 0xf4f1f5dd2801f94b732d240a46103089905ccd4e
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000f4f1f5dd2801f94b732d240a46103089905ccd4e


14). Liquidate bad mFRAX debt for user: 0x9f6dc2cf76fd22a0e5f11e0edde73502364ffbb8
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000009f6dc2cf76fd22a0e5f11e0edde73502364ffbb8


15). Liquidate bad mFRAX debt for user: 0x57e421c8a16bf0a609ef87e296cb931113a5e3ed
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000057e421c8a16bf0a609ef87e296cb931113a5e3ed


16). Liquidate bad mFRAX debt for user: 0x60298d41cef0759f1127fc5e48ba3b663a9e0889
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000060298d41cef0759f1127fc5e48ba3b663a9e0889


17). Liquidate bad mFRAX debt for user: 0xa3db05c72c79d52d2d37170a342a2c21c5e5d7c0
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000a3db05c72c79d52d2d37170a342a2c21c5e5d7c0


18). Liquidate bad mFRAX debt for user: 0xd4d70647651e84536eb218d5889ab764115c4d82
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000d4d70647651e84536eb218d5889ab764115c4d82


19). Liquidate bad mFRAX debt for user: 0xdd15c08320f01f1b6348b35eebe29fdb5ca0cda6
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000dd15c08320f01f1b6348b35eebe29fdb5ca0cda6


20). Liquidate bad mFRAX debt for user: 0xcbc21fbf92519f6d90c05a6fda1a7cb72fa6e02b
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000cbc21fbf92519f6d90c05a6fda1a7cb72fa6e02b


21). Liquidate bad mFRAX debt for user: 0x6722ae8c7a49553f1a80153517d1cfeca7eca5f7
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000006722ae8c7a49553f1a80153517d1cfeca7eca5f7


22). Liquidate bad mFRAX debt for user: 0x99b84a77f64e5acc269073cf082951c3ce57fe64
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000099b84a77f64e5acc269073cf082951c3ce57fe64


23). Liquidate bad mFRAX debt for user: 0xf98a854bc00eaa854894d79e11315a2114c58120
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000f98a854bc00eaa854894d79e11315a2114c58120


24). Liquidate bad mFRAX debt for user: 0x175a795ef04bc146fd6d6f852e5adec8b356e310
target: 0x1C55649f73CDA2f72CEf3DD6C5CA3d49EFcF484C
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000175a795ef04bc146fd6d6f852e5adec8b356e310


25). Liquidate bad mxcDOT debt for user 0xdd15c08320f01f1b6348b35eebe29fdb5ca0cda6
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000dd15c08320f01f1b6348b35eebe29fdb5ca0cda6


26). Liquidate bad mxcDOT debt for user 0x51d7193812b5b70e5e30df5c18ac2062c5f51c5e
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000051d7193812b5b70e5e30df5c18ac2062c5f51c5e


27). Liquidate bad mxcDOT debt for user 0xc265ba4d9ed33620978b03235fc9f5aa026da275
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000c265ba4d9ed33620978b03235fc9f5aa026da275


28). Liquidate bad mxcDOT debt for user 0x9f6dc2cf76fd22a0e5f11e0edde73502364ffbb8
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000009f6dc2cf76fd22a0e5f11e0edde73502364ffbb8


29). Liquidate bad mxcDOT debt for user 0x3a531c90e52a02817c0d31794d0ac4ea35a66602
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000003a531c90e52a02817c0d31794d0ac4ea35a66602


30). Liquidate bad mxcDOT debt for user 0x1fb540757cfd698b4a8f81e510ed09aa67a4f970
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000001fb540757cfd698b4a8f81e510ed09aa67a4f970


31). Liquidate bad mxcDOT debt for user 0x396a6d7a33655c45044143cb8a812227bf279578
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000396a6d7a33655c45044143cb8a812227bf279578


32). Liquidate bad mxcDOT debt for user 0x1f93dc0e5f249c8961027d447c973b9ce7ab7366
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000001f93dc0e5f249c8961027d447c973b9ce7ab7366


33). Liquidate bad mxcDOT debt for user 0xaaddc55883b7df9944d54c20f2822f476673cbc0
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000aaddc55883b7df9944d54c20f2822f476673cbc0


34). Liquidate bad mxcDOT debt for user 0xd2dff7007586be8f2e6cb84de65190b81adf6a9b
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000d2dff7007586be8f2e6cb84de65190b81adf6a9b


35). Liquidate bad mxcDOT debt for user 0x4f5ef03e870332a1b42453bbf57b8a041e89efe8
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000004f5ef03e870332a1b42453bbf57b8a041e89efe8


36). Liquidate bad mxcDOT debt for user 0xd4d70647651e84536eb218d5889ab764115c4d82
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000d4d70647651e84536eb218d5889ab764115c4d82


37). Liquidate bad mxcDOT debt for user 0x985c3e74201d8c4907e7d8db06bb1f83639bef0c
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000985c3e74201d8c4907e7d8db06bb1f83639bef0c


38). Liquidate bad mxcDOT debt for user 0x8dfd78676fa1929d1c7b64fbd3133e3b4ec305b3
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000008dfd78676fa1929d1c7b64fbd3133e3b4ec305b3


39). Liquidate bad mxcDOT debt for user 0xdc7428eeff0cdac1a45f310debb9af91708f47c9
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000dc7428eeff0cdac1a45f310debb9af91708f47c9


40). Liquidate bad mxcDOT debt for user 0x08c3e7b6e273d4434fa466ff23dba7c602a961a7
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000008c3e7b6e273d4434fa466ff23dba7c602a961a7


41). Liquidate bad mxcDOT debt for user 0xf9923ae543f039c71cd1bbc95ee3db6f36afcce6
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000f9923ae543f039c71cd1bbc95ee3db6f36afcce6


42). Liquidate bad mxcDOT debt for user 0x3769859a5efa6133cd74c5eb5080f46beffb6cef
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f70000000000000000000000003769859a5efa6133cd74c5eb5080f46beffb6cef


43). Liquidate bad mxcDOT debt for user 0xb3e6420941acc44c2996666b4b5c998c1545fc19
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f7000000000000000000000000b3e6420941acc44c2996666b4b5c998c1545fc19


44). Liquidate bad mxcDOT debt for user 0x54dc6782d6fc5fc05f8486d365186ff25cc44ba7
target: 0xD22Da948c0aB3A27f5570b604f3ADef5F68211C3
payload
0x28d8cd8c000000000000000000000000949d6a0e3b1064d498d529a388b953b344cd13f700000000000000000000000054dc6782d6fc5fc05f8486d365186ff25cc44ba7

`;


// Regular expression to match the user addresses in the input text
const addressRegex = /user:? (0x[a-fA-F0-9]{40})/g;

// Function to extract addresses and remove duplicates
function extractUniqueAddresses(text) {
    const matches = text.matchAll(addressRegex);
    const addresses = [];
    for (const match of matches) {
        addresses.push(toChecksumAddress(match[1]));
    }

    console.log(`Total matches found (before deduping): ${addresses.length}`);
    return [...new Set(addresses)]; // Remove duplicates
}

const uniqueAddresses = extractUniqueAddresses(inputText);

console.log(uniqueAddresses);
console.log(`Unique addresses count: ${uniqueAddresses.length}`);