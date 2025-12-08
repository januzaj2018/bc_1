#import "@preview/cetz:0.4.2": canvas, draw
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)

#set text(
  font: "Linux Libertine",
  size: 11pt,
  lang: "en"
)

// Colors
#let primary-color = rgb("#007FFF") 
#let accent-color = rgb("#00B9E8")  
#let code-bg = rgb("#f1f2f6")       
#let border-color = rgb("#dcdde1")

// Headings
#show heading: set text(fill: primary-color, font: "Linux Biolinum")
#show heading.where(level: 1): it => [
  #v(1em)
  #line(length: 100%, stroke: 1pt + primary-color)
  #text(1.2em, weight: "bold", it)
  #v(0.5em)
]

#let question(title, body) = {
  v(1em)
  block(
    fill: rgb("#f5fbfd"),
    stroke: (left: 3pt + accent-color),
    inset: 1em,
    width: 100%,
    radius: 4pt,
    [
      #text(weight: "bold", fill: primary-color)[== #title] \
      #body
    ]
  )
}

#let answer(body) = {
  block(
    width: 100%,
    inset: (left: 1em),
    [#text(style: "italic", fill: rgb("#555"))[Answer:] \ #body]
  )
}

#let img_placeholder(height_val, caption_text) = {
  align(center)[
    #rect(
      width: 80%, 
      height: height_val, 
      fill: rgb("#f8f9fa"), 
      stroke: (dash: "dashed", paint: rgb("#ccc")),
      radius: 5pt
    )[
      #align(center + horizon)[
        #text(fill: rgb("#999"))[#text(size: 20pt)[📷] \ Replace with: #caption_text \ (Use `#image("filename.png")`)]
      ]
    ]
    #text(size: 9pt, style: "italic")[Figure: #caption_text]
  ]
}

// ==========================================
// TITLE PAGE
// ==========================================

#align(center + horizon)[
  #text(size: 24pt, weight: "bold", fill: primary-color)[Blockchain Technologies 1]
  
  #v(1em)
  #text(size: 16pt)[Assignment - 1]
  
  #v(2em)
  #line(length: 50%, stroke: 1pt )
  #v(1em)

  *Aibek* \

  #datetime.today().display()
  
  #v(1em)
  #line(length: 50%, stroke: 1pt )
]

#pagebreak()
#outline(indent: auto,
depth: 2)
#pagebreak()

// ==========================================
// MODULE 1: INTRODUCTION
// ==========================================
= Module 1: Introduction to Blockchain Technology

 #question("1. Distributed vs. Centralized Ledgers")[
  Explain how a distributed ledger differs from a centralized ledger in terms of trust, confidentiality, fault-tolerance, and attack surface. Provide at least 3 real-world examples for each.
]
#set par(first-line-indent: 1em)
#answer[

 The essential discrepancy between distributed ledger (DL), commonly represented by blockchain technology, and centralized ledger (CL), usually a traditional database, is their architecture and the mechanisms they use for data integrity and coordination. A centralized system has clients that are connected to a single central server governed by an administrator, while a distributed ledger network is based on the peer-to-peer model where control as well as data distribution occur across many nodes. 
  
=== Trust   

==== Centralized Ledger:
  #list(
    [#strong[Trust Model]: Centralized systems rely on a trust-based model. Trust is implicitly or explicitly placed in a single central authority, administrator, or intermediary (like a bank) who manages the entire system and controls the data],
[#strong[Technical Reasoning]: The integrity and authenticity of the ledger are maintained exclusively by this single entity, meaning there is no technical guarantee against malicious actions by the controller]
  )

==== Distributed Ledger:
- #strong[Trust Model]: Distributed ledgers operate on a trustless model (or distributed trust). Trust is established and maintained through cryptographic security and a consensus mechanism rather than relying on a single third party,,. Participants collectively agree on the state of the network.
- #strong[ Technical Reasoning: ] Consensus protocols (like Proof-of-Work or Byzantine Fault Tolerance variants) ensure that new records are added only if participants collectively agree to do so. Transparency, where all participants possess the same verifiable information, reinforces this trust among participants





#figure(
  canvas(length: 1cm, {
    import draw: *

    // Central server box
    rect((0,0), (12,2.5), fill: rgb("#e3f2fd"), stroke: blue + 2pt, name: "server")
    content("server.center", padding: .4, [Central Server], weight: "bold", size: 14pt)

    // Client positions (hand-placed for a nice symmetric look)
    let positions = (
      (2, 6),    // top-left
      (4.5, 7),  // top
      (7.5, 7),  // top-right
      (10, 6),   // right-top
      (9.5, 4),  // right-bottom
      (2.5, 4),  // left-bottom
    )

    for (i, pos) in positions.enumerate() {
      line(pos, "server", stroke: (paint: gray, thickness: 1.3pt))
      // Draw client circle
      circle(pos, radius: .65, fill: luma(230), stroke: luma(100) + 1.5pt, name: "c" + str(i))
      content("c" + str(i), [Client], size: 11pt)

      // Simple line from client to the edge of the server box
      // Optional arrow pointing to server:
      // line(pos, "server", mark: (end: ">"), stroke: (paint: gray, thickness: 1.3pt))
    }

    // Caption below the canvas
    content((6, -0.5), [Centralized Ledger (CL): Single Point of Control], size: 12pt)
  }),
  caption: [Diagram: Centralized Control],
)
#figure(
  canvas(length: 1cm, {
    import draw: *

    // 7 nodes arranged in a nice circle (classic decentralized/P2P look)
    let n = 7
    let radius = 4.2
    let center = (6, 5)

    for i in range(n) {
      let angle = i * 360deg / n - 90deg
      let pos = (center.at(0) + radius * calc.cos(angle),
                 center.at(1) + radius * calc.sin(angle))

      // Draw client node
      circle(pos, radius: .7, fill: luma(230), stroke: luma(80) + 1.8pt, name: "node" + str(i))
      content("node" + str(i), [Client], size: 11pt, weight: "semibold")
    }

    // Connect each node to every other node (full mesh = fully decentralized)
    // We only draw connections i → j where j > i to avoid duplicates
    for i in range(n) {
      for j in range(i + 1, n) {
        line("node" + str(i), "node" + str(j),
             stroke: (paint: gray, thickness: 1.1pt, dash: "densely-dotted"))
      }
    }

    // Optional: highlight that it's a full mesh
    // You can reduce connections if too cluttered (e.g., only connect to nearest 3–4 neighbors)
    content((6, -0.4), [Decentralized Ledger (DL): No Single Point of Control], size: 13pt)
  }),
  caption: [Diagram: Decentralized / Peer-to-Peer Network],
)


=== Confidentiality

==== Centralized Ledger (CL):
- #strong[ Data Access: ] The central authority is responsible for maintaining confidentiality and the access control policies established by it are the means through which this is done. The data is so to speak owned by the controlling entity, and access is limited to a few select individuals.
- #strong[ Technical Reasoning: ] The central server’s data security utilizes traditional methods such as authentication, access control, and physical security measures.

==== Distributed Ledger (DL):
- #strong[ Data Access: ] Confidentiality is a big issue and very different for each type of DL:

    - Public (Permissionless) DLs has the main concern of transparency, thus all transactions are recorded in a shared, publicly available digital ledger. The user identities are usually anonymous but the transaction data is generally public.
  
    - Private/Consortium (Permissioned) DLs have the access limited only to the known participants, thus providing both confidentiality and transparency only within that group.

- #strong[ Technical Reasoning: ] Cryptography is the main source of security for confidentiality and uses methods like encryption to the communication links (in transit) or the data when it is stored (at rest)

=== Fault-tolerance

==== Centralized Ledger (CL):
- #strong[Resilience:] Centralized systems have very low fault tolerance as it is based on the one and only central server. This is exactly what a single point of failure means.
- #strong[ Technical Reasoning: ] When the only central node ceases to function, the whole database becomes user-unreachable. The system is stuck because there is no distributed copy or coordinated failover, which is not the case since the core design is not supporting it.

==== Distributed Ledger (DL):
- #strong[Resilience:] High fault-tolerance is the very property of distributed ledgers. The reason is that the data being distributed over many nodes, and the system is still available and on-going if one or more nodes go down.
- #strong[ Technical Reasoning: ] Replication is the way to bring about fault tolerance. Typically, distributed systems that require consensus operate based on strict thresholds to guarantee safety, such as N≥3F+1 for tolerating Byzantine faults (where N is total nodes and F is faulty nodes). The system achieves liveness as long as a majority or a sufficient quorum of non-faulty nodes remains up and running and continues to process requests
  
=== Attack Surface

==== Centralized Ledger (CL):

- #strong[ Vulnerability: ] The entire attack surface is concentrated in one single point-the central authority.
- #strong[ Technical Reasoning: ] In total, an invader aspiring to disrupt, corrupt, or freeze the system will only have to take over the central node (the database, API endpoints, or the governing administrator)together with the system. Once the point of failure is breached, the hacker has full control of the data and system operations,.

==== Distributed Ledger (DL):
- #strong[ Vulnerability: ] The network's overall security is based on the fact that all participating nodes are the points of attack. Through cryptographic hashing, the data is secured so that a chain is formed which is almost impossible to alter and which has very high resistance to penetration through tampering.

- #strong[ Technical Reasoning: ] An adversary who wants to execute a devastating attack must first break the economic barriers and seize the control of a considerable part of the network which usually means a supermajority or more than 50% of the computational power (in Proof of Work networks like Bitcoin) or over one-third of the total validator stake/nodes (in BFT/PoS networks). Changing a record is practically impossible because its hash is linked to consecutive blocks, hence altering one record requires recalculating the hashes of all subsequent blocks, making data tampering-proof.
  
  // Tip: Use a table for comparison
  #table(
    columns: (auto, 1fr, 1fr),
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    inset: 10pt,
    [*Feature*], [*Centralized Ledger*], [*Distributed Ledger*],
    [Trust], [Relies on a single authority], [Trust is distributed among nodes],
    [Confidentiality], [High (Owner controls access)], [Varies (Public vs. Permissioned)],
    [Fault-tolerance], [Low (Single point of failure)], [High (Redundancy)],
    [Attack Surface], [Central server is the target], [Consensus mechanism/Nodes],
  )
  
  *Real-World Examples:*
 #table(
    columns: (1.3fr, 2fr, 2fr,3fr),
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    inset: 10pt,
    [*Ledger Type*], [*Trust*], [*Confidentiality*],[*Fault-Tolerance*],
    [Centralized], [Traditional Banking Systems (like SWIFT, single bank ledgers)], [Corporate ERP Systems (data managed by the company)], [Traditional Web2 Applications (for example, a service running on one cloud server/database)],
    [Distributed], [Bitcoin (Public, permissionless network based on Proof-of-Work)], [Ethereum (Public DApp platform using smart contracts and consensus)],[Consortium Blockchains (like supply chain solutions involving several organizations using permissioned networks)],
 )
]

#question("2. Definition of Immutability")[
  Provide a rigorous technical definition of immutability. Explain how hash functions contribute to this and describe one scenario where immutability fails.
]

#answer[
  
Immutability in a blockchain refers to an unalterable and non-removable transaction after it has been confirmed and included in a block that belongs to the canonical chain. The ledger is only for adding new transactions: newly processed blocks can only be added one after another, and the entire history is kept permanently. Mistakes are not rectified by replacing them in the past, but rather with the addition of new reversing transactions.

How Hash Chaining Ensures Immutability
The link between the blocks is established with the cryptographic hash of the preceding block:

An alteration of even 1 bit in a past block dramatically changes its hash (avalanche effect).

This leads to the "previous hash" reference in the next block being broken.

To cover up the tampering, a hacker needs to perform the same intense computing work that involves re-mining the compromised block plus all the consecutive blocks.

In a Proof-of-Work system, the massive power cost needed makes this practically impossible.

==== Diagram illustration


#figure(
  canvas(length: 1cm, {
    import draw: *

    // Block positions
    let positions = ((1, 4), (7, 4), (13, 4))
    let labels = ("Block n-1", "Block n", "Block n+1")
    let ids = ("prev", "current", "next")

    // Draw the three blocks
    for (i, pos) in positions.enumerate() {
      let id = ids.at(i)

      // Main block rectangle
      rect(pos, (pos.at(0)+5, pos.at(1)+4),
           fill: rgb("#e3f2fd"),
           stroke: blue + 2pt,
           radius: 0.4,
           name: id)

      // Block title
      content((pos.at(0)+2.5, pos.at(1)+3.4), labels.at(i), weight: "bold")

      // Generic content
      content((pos.at(0)+2.5, pos.at(1)+2.2), [
        Transactions\
        Nonce, Timestamp, etc.
      ], anchor: "north")

      // Previous Hash field (except first block)
      if i > 0 {
        content((pos.at(0)+2.5, pos.at(1)+0.8),
          text(fill: red.darken(50%), weight: "bold")[
            Previous Hash = #if i == 1 { ( text("Hash" + sub("n-1")) )} else { text("Hash" + sub("n")) }
          ],
          anchor: "north")
      }
    }

    // Hash arrows pointing right
    line((6, 5.8), (7, 5.8), mark: (end: ">"), stroke: blue + 1.5pt)
    content((5, 6.1), [Hash], weight: "semibold")

    line((12, 5.8), (13, 5.8), mark: (end: ">"), stroke: blue + 1.5pt)
    content((11, 6.1), [Hash], weight: "semibold")

    // Dotted chain lines below blocks
    line((1, 3), (18, 3), stroke: (paint: gray, dash: "densely-dotted", thickness: 1.5pt))

    // Caption
    content((9.5, 2.5), [Blockchain Hash Chaining – Enforcing Immutability])
  }),
  caption: [
    Each block stores the hash of the previous block (in red). \
    Modifying any block changes its hash, breaking the chain.
  ],
)

Immutability isn't absolute—it's economic finality. Suppose an adversary gains control of the hash power of the network that is more than 50%.

They first make the transaction public and then create a hidden chain that does not include that transaction and is longer than the public one.
When the hidden chain is revealed, the participants in the network apply the longest-chain rule and accept it.
The time of the original transaction is then erased from the canonical history → successful double-spend.

In this way, the immutability of the blockchain is guaranteed by cryptography but the costs that have to be borne for acquiring majority hash power finally determine the security.
  
]

#question("3. Transparency vs. Privacy")[
  Evaluate blockchain transparency vs. privacy. Compare Bitcoin vs. Ethereum and explain mixers, stealth addresses, and ZK proofs.
]

#answer[
  // [YOUR ANSWER HERE]
]

#question("4. DApp Architecture")[
  Define DApp architecture in detail. Describe interactions between Smart Contracts, Off-chain backend, Frontend, Wallets, and Nodes.
]

#answer[
  // [YOUR ANSWER HERE]
  #img_placeholder(4cm, "DApp Architecture Diagram")
  
  *Component Interactions:*
  - *Smart Contract Layer:* ...
  - *Wallets:* ...
]

#pagebreak()

// ==========================================
// MODULE 2: CRYPTOGRAPHY (PRACTICE)
// ==========================================

= Module 2: Cryptography Fundamentals

#question("1. SHA-256 Computations")[
  Compute SHA-256 hashes using Node.js, an online tool, and Linux terminal.
]

#answer[
  *1. Node.js Output:*
  #raw(lang: "bash", block: true, "Paste your Node.js output here")

  *2. Linux Terminal Output:*
  #raw(lang: "bash", block: true, "Paste your sha256sum output here")
  
  *Comparison:* // Explain why they are identical
]

#question("2. Collision Resistance")[
  Demonstrate collision resistance by modifying one bit of input. Explain the avalanche effect and the birthday paradox.
]

#answer[
  *Original Hash:* `[Paste Hash]` \
  *Modified Hash:* `[Paste New Hash]`
  
  The hashes are drastically different because...

  *Probability of Collision:*
  Using the Birthday Paradox formula:
  //$ P(n) \approx 1 - e^(-n^2 / (2H)) $
  // Add your calculation here
]

#pagebreak()

// ==========================================
// MODULE 3: DEV ENVIRONMENT
// ==========================================

= Module 3: Developer Environment Setup

#question("Activity Requirements")[
  Set up a blockchain environment (Node.js, npm, VS Code). Initialize a project and install `web3`, `ethers`, `crypto-js`.
]

#answer[
  *Package Installation & Version Check:*
  
  #img_placeholder(6cm, "Screenshot of Terminal (node -v, npm -v) and package.json")

  *Package Explanation:*
  - *web3:* ...
  - *ethers:* ...
  - *crypto-js:* ...
]

#pagebreak()

// ==========================================
// MODULE 4: DEEP TECHNICAL ANSWERS
// ==========================================

= Module 4: Models & Architecture

#question("1. Bitcoin's UTXO Model")[
  Draw a diagram of UTXO flow. Explain script validation, parallelism, and stateless validation.
]

#answer[
  #img_placeholder(5cm, "UTXO Flow Diagram")
  
  *Script Validation Steps:*
  1. ...
  2. ...
]

#question("2. Ethereum's Account Model")[
  Explain EOA vs. Contract Accounts. Describe nonce, balance, storage, codeHash. Provide a JSON example.
]

#answer[
  *Account State JSON Example:*
  
]
  


#question("3. Security Implications")[
  Analyze Replay vulnerabilities, Transaction malleability, Double-spend handling, Smart contract attack surface, and State bloat.
]

#answer[
  // [YOUR ANSWER HERE]
]

#question("4. EVM Architecture")[
  Explain EVM bytecode execution, Stack-based model, Gas metering, and Error handling.
]

#answer[
  // [YOUR ANSWER HERE]
]

#question("5. Smart Contracts")[
  Explain gas cost model and storage. Why are writes expensive? Provide code optimization example.
]

#answer[
  *Inefficient Code:*
  

  *Optimized Code:*
  
  
  *Explanation:* ...
]

#pagebreak()

// ==========================================
// MODULE 5: LAB EXERCISE
// ==========================================

= Module 5: Wallets & Transactions

#question("Step 1: Wallet Installation")[
  Install MetaMask/Trust/Rabby. Submit screenshot of interface and public address.
]

#answer[
  #img_placeholder(6cm, "Wallet Interface Screenshot")
  *Public Address:* `0x...`
]

#question("Step 2: Transaction Inspection")[
  Decode a raw Bitcoin or Ethereum transaction.
]

#answer[
  *Selected Blockchain:* Ethereum/Bitcoin
  
  *Transaction Hash:* `0x...`

  *Decoded Fields:*
  #table(
    columns: (1fr, 2fr),
    inset: 8pt,
    [*Field*], [*Value / Explanation*],
    [Nonce], [...],
    [Gas Price], [...],
    [Gas Limit], [...],
    [Value], [...],
    [Data/Input], [...],
    [To], [...],
  )
  
  *Logic Explanation:*
  // Explain how gas was calculated or UTXO consumed
]

// ==========================================
// END OF ASSIGNMENT
// ==========================================
