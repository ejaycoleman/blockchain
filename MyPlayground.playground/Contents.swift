struct Block  {
    var dataPayload = ""
    var previousHash = 0
    var hash = 0
    var nonce = 0 // number used to change the hash for each block
}

func hash(data: String) -> Int {
    // generate a hash for the block
    var hash: UInt32 = 0x0
    
    for character in data {
        hash = hash ^ UnicodeScalar(String(character))!.value // XOR the hash and the unicode value of each character
        hash = hash &* 0x1234567 // &* is an operator for multiplying but cycling over (to prevent integer overflow of 32bit int)
    }
   
    return Int(hash)
}

func mineBlock(data: String) -> Int {
    // this basically makes it harder for hashes to be generated
    // see *
    var nonce = 0
    var hashResult = 0
    var dataToHash = ""
    
    while(true) { // keep generating new nonce values and checking them
        dataToHash = data + String(nonce)

        hashResult = hash(data: dataToHash)
        if ((hashResult & 0xff) == 0xAA) { // if the hashed valuue (including the new nonce) ends in 'aa' (hash AND 0b11111111, 0xff)
            // * the fact this is only requiring two characters to be As makes it easier to find a hash
            // if it needed to end in 6 As, it would take more time to find the correct nonce to generate this
            // Bitcoin changes this 'criteria'/difficulty, so as new computers are mining, a new result is generated every ~10mins
            // if there are more computers, its likely the current criteria is too low (maybe found every minute) and will need to be made more difficult
            
            return nonce
        }
        nonce += 1 // otherwise change the nonce and try again
    }
}

func createBlock(previousHash: Int, payload: String) -> Block {
    var newBlock = Block()
    newBlock.dataPayload = payload
    newBlock.previousHash = previousHash
    let dataToHash = newBlock.dataPayload + String(newBlock.previousHash) // hash payload and previous hash
    // hashing with the previous block means that data is 'carried forward'
    // if a value was changed in the previous block, its hash would change which would also change the following block's hashes
    
    newBlock.nonce = mineBlock(data: dataToHash) // find nonce (value to satisfy hash difficulty)

    let actualDataToHash = dataToHash + String(newBlock.nonce)
    
    newBlock.hash = hash(data: actualDataToHash)
    
    print("New Block created")
    print("Block data: \(newBlock.dataPayload)")
    print("Previous hash: 0x\(String(newBlock.previousHash, radix: 16))")
    print("Current hash: 0x\(String(newBlock.hash, radix: 16))")
    print("Nonce: \(String(newBlock.nonce, radix: 10)) \n")
    
    return newBlock
}

func main () {
    let myBlock1 = createBlock(previousHash: 0, payload: "This is the first block for 0") // create block with previous hash as 0 (first block)
    _ = createBlock(previousHash: myBlock1.hash, payload: "This is the first block for 92cdcfaa") // create a second block using the hash of the previous block
}

main()
