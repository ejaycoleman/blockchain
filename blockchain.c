//
//  blockchain.c
//  
//
//  Created by Elliott on 03/06/2019.
//

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

typedef struct {
    char data[256];
    int prevHash;
    int hash;
    int nonce;
} Block;

int hash(char data[]) {
    int hash = 0;
    for (int i = 0; i < strlen(data); i++) {
        hash = hash ^ data[i];
        hash = hash * 0x1234567;
    }
    
    return hash;
}

int mine_block(char data[]){
    int nonce = 0;
    int hash1;
    
    char dataToHash[256];
    
    while(1) {
        sprintf(dataToHash,"%s%d", data, nonce);
        hash1 = hash(dataToHash);
        
        if ((hash1 & 0xff) == 0xAA) {
            return nonce;
        }
        
        nonce++;
        //printf("%x\n", hash1);
    }
    
    return nonce;
}

Block createBlock(int previousHash) {
    Block newBlock;
    sprintf(newBlock.data, "This is the first block for %x", previousHash);
    newBlock.prevHash = previousHash;
    char dataToHash[256];
    sprintf(dataToHash, "%s%d", newBlock.data, newBlock.prevHash);

    newBlock.nonce = mine_block(dataToHash);
    char dataToHashN[256];
    sprintf(dataToHashN, "%s%d", dataToHash, newBlock.nonce);
    newBlock.hash = hash(dataToHashN);
    
    printf("New Block\n\nBlock data: %s\nPrevious Hash: %x\nHash: %x\nNonce: %x\n\n\n", newBlock.data, newBlock.prevHash, newBlock.hash, newBlock.nonce);
    
    
    return newBlock;
}


int main() {
    Block myBlock1 = createBlock(0);
    Block myBlock2 = createBlock(myBlock1.hash);
    
    
    
    

    return 0;
}


