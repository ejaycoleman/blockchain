struct Block  {
    var dataPayload = ""
    var previousHash = 0
    var hash = 0
    var nonce = 0
}

func hash(data: String) -> Int {
    var hash: UInt32 = 0x0
    
    for character in data {
        hash = hash ^ UnicodeScalar(String(character))!.value
        hash = hash &* 0x1234567
    }
   
    return Int(hash)
}

func mineBlock(data: String) -> Int {
    var nonce = 0
    var hashResult = 0
    var dataToHash = ""
    
    while(true) {
        dataToHash = data + String(nonce)

        hashResult = hash(data: dataToHash)
        if ((hashResult & 0xff) == 0xAA) {
            return nonce
        }
        nonce += 1
    }
}

func createBlock(previousHash: Int, payload: String) -> Block {
    var newBlock = Block()
    newBlock.dataPayload = payload
    newBlock.previousHash = previousHash
    let dataToHash = newBlock.dataPayload + String(newBlock.previousHash)
    
    newBlock.nonce = mineBlock(data: dataToHash)

    let actualDataToHash = dataToHash + String(newBlock.nonce)
    
    newBlock.hash = hash(data: actualDataToHash)
    
    print("New Block created")
    print("Block data: \(newBlock.dataPayload)")
    print("Previous hash: \(String(newBlock.previousHash, radix: 16))")
    print("Current hash: \(String(newBlock.hash, radix: 16))")
    print("Nonce: \(String(newBlock.nonce, radix: 10)) \n")
    
    return newBlock
}

func main () {
    let myBlock1 = createBlock(previousHash: 0, payload: "This is the first block for 0")
    _ = createBlock(previousHash: myBlock1.hash, payload: "This is the first block for 92cdcfaa")
}

main()
