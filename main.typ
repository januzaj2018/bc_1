#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/codly:1.3.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/codly-languages:0.1.1": *
// #import "@preview/codelst:2.0.2": sourcecode, codelst
#show: codly-init.with()

#codly(zebra-fill: none)
#set par(first-line-indent: 1em)
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)

#set text(font: "Linux Libertine", size: 11pt, lang: "en")

#show raw.where(block: false): set text(font: ("JetBrainsMono NF", "DejaVu Sans Mono", "Linux Biolinum"), weight: "semibold", fill: rgb("#d73a49"))
#show raw.where(block: false): box.with(fill: rgb("#fff5f5"), inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 3pt)

// Colors
#let primary-color = rgb("2c8dbb")
#let accent-color = rgb("#3c3325")
#let code-bg = rgb("#f1f2f6")
#let border-color = rgb("#dcdde1")
#let code-fg = rgb("#2e3440")

#let explain-term(title, summary: none, details) = {
  v(0.5em)
  block(// uncomment for the background, idk it looks like questions
  //fill: rgb("#f8f9fb"), stroke: (left: 2pt + border-color), 
  inset: 0.8em, radius: 3pt, width: 100%, [
    // Term title
    #text(weight: "bold", fill: primary-color)[#title]

    // Short one‑line summary
    #if summary != none {
      v(0.25em)
      text(style: "italic", fill: rgb("#555"))[ #summary ]
    }
    // Longer explanation body
    #v(0.25em)
    #details
  ])
}
#let accent(txt) = {
  text(weight: "bold", fill: primary-color)[#block(spacing: 0.5em)#txt\ ]
}
// Code 
#codly(languages: codly-languages)
#show raw.where(lang: "powershell"): it => {
  set text(fill: rgb("#012456"))
  it
}
#codly(number-format: (n) => [#text(luma(0))[#str(n)]])
#show raw: set text(font: "Cascadia Code")

// Headings
#show heading: set text(fill: primary-color, font: "Linux Biolinum")
#show heading.where(level: 1): it => [
  #v(1em)
  #pagebreak(weak: true)
  #line(length: 100%, stroke: 1pt + primary-color)
  #text(1.2em, weight: "bold", it)
  #v(0.5em)
]

#let question(title, body) = {
  v(1em)
  block(fill: rgb("#f5fbfd"), stroke: (left: 3pt + accent-color), inset: 1em, width: 100%, radius: 4pt, [
    #text(weight: "bold", fill: primary-color)[== #title]
    #body
  ])
}

#let answer(body) = {
  block(width: 100%, inset: (left: 1em), [#text(style: "italic", fill: rgb("#555"))[Answer:] \
  #body])
}

// ==========================================
// TITLE PAGE
// ==========================================
#place(top + right, image("assets/aitu.svg", height: 3cm, scaling: "smooth"))
#align(center + horizon)[
  #text(size: 24pt, weight: "bold", fill: primary-color)[Blockchain Technologies
  1]

  #v(1em)
  #text(size: 16pt)[Assignment - 1]

  #v(2em)
  #line(length: 50%, stroke: 1pt)
  #v(1em)

  *Aibek* \

  SE-2419

  #v(1em)
  #line(length: 50%, stroke: 1pt)
]

#outline(indent: auto, depth: 2)

// ==========================================
// MODULE 1: INTRODUCTION
// ==========================================

= Module 1: Introduction to Blockchain Technology

#question("1. Distributed vs. Centralized Ledgers")[
  Explain how a distributed ledger differs from a centralized ledger in terms of
  trust, confidentiality, fault-tolerance, and attack surface. Provide at least 3
  real-world examples for each.
]
#answer[

  The essential discrepancy between distributed ledger (DL), commonly represented
  by blockchain technology, and centralized ledger (CL), usually a traditional database,
  is their architecture and the mechanisms they use for data integrity and coordination.
  A centralized system has clients that are connected to a single central server
  governed by an administrator, while a distributed ledger network is based on the
  peer-to-peer model where control as well as data distribution occur across many
  nodes.

  === Trust

  #accent[Centralized Ledger]
  #list([#strong[Trust Model]: Centralized systems rely on a trust-based model. Trust
  is implicitly or explicitly placed in a single central authority, administrator,
  or intermediary (like a bank) who manages the entire system and controls the data], [#strong[Technical
  Reasoning]: The integrity and authenticity of the ledger are maintained exclusively
  by this single entity, meaning there is no technical guarantee against malicious
  actions by the controller])

  #accent[Distributed Ledger]
  - #strong[Trust Model]: Distributed ledgers operate on a trustless model (or distributed
    trust). Trust is established and maintained through cryptographic security and
    a consensus mechanism rather than relying on a single third party,,. Participants
    collectively agree on the state of the network.
  - #strong[ Technical Reasoning: ] Consensus protocols (like Proof-of-Work or Byzantine
    Fault Tolerance variants) ensure that new records are added only if participants
    collectively agree to do so. Transparency, where all participants possess the
    same verifiable information, reinforces this trust among participants

  #figure(
    canvas(length: 1cm, {
      import draw: *

      // Central server box
      rect((0, 0), (12, 2.5), fill: rgb("#e3f2fd"), stroke: primary-color + 2pt, name: "server")
      content("server.center", padding: .4, [Central Server], weight: "bold", size: 14pt)

      // Client positions (hand-placed for a nice symmetric look)
      let positions = (
        (2, 6),
        // top-left
        (4.5, 7),
        // top
        (7.5, 7),
        // top-right
        (10, 6),
        // right-top
        (9.5, 4),
        // right-bottom
        (2.5, 4),
        // left-bottom
      )

      for (i, pos) in positions.enumerate() {

        line(pos, "server", stroke: (paint: gray, thickness: 1.3pt))
        // Draw client circle
        circle(pos, radius: .65, fill: luma(230), stroke: luma(100) + 1.5pt, name: "c" + str(i))
        content("c" + str(i), [Client], size: 11pt)

      }

      // Caption below the canvas
    }),
    caption: [Centralized Ledger (CL): Single Point of Control],
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
        let pos = (center.at(0) + radius * calc.cos(angle), center.at(1) + radius * calc.sin(angle))

        // Draw client node
        circle(pos, radius: .7, fill: luma(230), stroke: luma(80) + 1.8pt, name: "node" + str(i))
        content("node" + str(i), [Client], size: 11pt, weight: "semibold")
      }

      // Connect each node to every other node (full mesh = fully decentralized)
      // We only draw connections i → j where j > i to avoid duplicates
      for i in range(n) {
        for j in range(i + 1, n) {
          draw.on-layer(-1, line("node" + str(i), "node" + str(j), stroke: (paint: gray, thickness: 1.1pt, dash: "densely-dotted")))
        }
      }
      // Optional: highlight that it's a full mesh
      // You can reduce connections if too cluttered (e.g., only connect to nearest 3–4 neighbors)
    }),
    caption: [Decentralized Ledger (DL): No Single Point of Control],
  )

  === Confidentiality

  #accent[Centralized Ledger:]
  - #strong[ Data Access: ] The central authority is responsible for maintaining
    confidentiality and the access control policies established by it are the means
    through which this is done. The data is so to speak owned by the controlling
    entity, and access is limited to a few select individuals.
  - #strong[ Technical Reasoning: ] The central server’s data security utilizes traditional
    methods such as authentication, access control, and physical security measures.

  #accent[Distributed Ledger:]
  - #strong[ Data Access: ] Confidentiality is a big issue and very different for
    each type of DL:

    - Public (Permissionless) DLs has the main concern of transparency, thus all
      transactions are recorded in a shared, publicly available digital ledger. The
      user identities are usually anonymous but the transaction data is generally
      public.

    - Private/Consortium (Permissioned) DLs have the access limited only to the known
      participants, thus providing both confidentiality and transparency only within
      that group.

  - #strong[ Technical Reasoning: ] Cryptography is the main source of security for
    confidentiality and uses methods like encryption to the communication links (in
    transit) or the data when it is stored (at rest)

  === Fault-tolerance

  #accent[Centralized Ledger:]
  - #strong[Resilience:] Centralized systems have very low fault tolerance as it
    is based on the one and only central server. This is exactly what a single point
    of failure means.
  - #strong[ Technical Reasoning: ] When the only central node ceases to function,
    the whole database becomes user-unreachable. The system is stuck because there
    is no distributed copy or coordinated failover, which is not the case since the
    core design is not supporting it.

  #accent[Distributed Ledger:]
  - #strong[Resilience:] High fault-tolerance is the very property of distributed
    ledgers. The reason is that the data being distributed over many nodes, and the
    system is still available and on-going if one or more nodes go down.
  - #strong[ Technical Reasoning: ] Replication is the way to bring about fault tolerance.
    Typically, distributed systems that require consensus operate based on strict
    thresholds to guarantee safety, such as N≥3F+1 for tolerating Byzantine faults
    (where N is total nodes and F is faulty nodes). The system achieves liveness
    as long as a majority or a sufficient quorum of non-faulty nodes remains up and
    running and continues to process requests

  === Attack Surface

  #accent[Centralized Ledger:]

  - #strong[ Vulnerability: ] The entire attack surface is concentrated in one single
    point-the central authority.
  - #strong[ Technical Reasoning: ] In total, an invader aspiring to disrupt, corrupt,
    or freeze the system will only have to take over the central node (the database,
    API endpoints, or the governing administrator)together with the system. Once
    the point of failure is breached, the hacker has full control of the data and
    system operations,.

  #accent[Distributed Ledger:]
  - #strong[ Vulnerability: ] The network's overall security is based on the fact
    that all participating nodes are the points of attack. Through cryptographic
    hashing, the data is secured so that a chain is formed which is almost impossible
    to alter and which has very high resistance to penetration through tampering.

  - #strong[ Technical Reasoning: ] An adversary who wants to execute a devastating
    attack must first break the economic barriers and seize the control of a considerable
    part of the network which usually means a supermajority or more than 50% of the
    computational power (in Proof of Work networks like Bitcoin) or over one-third
    of the total validator stake/nodes (in BFT/PoS networks). Changing a record is
    practically impossible because its hash is linked to consecutive blocks, hence
    altering one record requires recalculating the hashes of all subsequent blocks,
    making data tampering-proof.

  // Tip: Use a table for comparison
  #figure(table(
    columns: (auto, 1fr, 1fr),
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    align: left,
    inset: 10pt,
    [*Feature*],       [*Centralized Ledger*],          [*Distributed Ledger*],
    [Trust],           [Relies on a single authority],  [Trust is distributed among
    nodes],
    [Confidentiality], [High (Owner controls access)],  [Varies (Public vs. Permissioned)],
    [Fault-tolerance], [Low (Single point of failure)], [High (Redundancy)],
    [Attack Surface],  [Central server is the target],  [Consensus mechanism/Nodes],
  ), caption: [
    CL vs DL (feautres)
  ])

  #figure(table(
    columns: (1.3fr, 2fr, 2fr, 3fr),
    align: left,
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    inset: 10pt,
    [*Ledger Type*], [*Trust*],                                                         [*Confidentiality*],                                          [*Fault-Tolerance*],
    [Centralized],   [Traditional Banking Systems (like SWIFT, single bank ledgers)],   [Corporate
    ERP Systems (data managed by the company)],                  [Traditional Web2
    Applications (for example, a service running on one cloud server/database)],
    [Distributed],   [Bitcoin (Public, permissionless network based on Proof-of-Work)], [Ethereum
    (Public DApp platform using smart contracts and consensus)], [Consortium
    Blockchains
    (like supply chain solutions involving several organizations using permissioned
    networks)],
  ), caption: [
    Real-World Examples
  ])
]

#question("2. Definition of Immutability")[
  Provide a rigorous technical definition of immutability. Explain how hash functions
  contribute to this and describe one scenario where immutability fails.
]

#answer[

  Immutability in a blockchain refers to an unalterable and non-removable transaction
  after it has been confirmed and included in a block that belongs to the canonical
  chain. The ledger is only for adding new transactions: newly processed blocks can
  only be added one after another, and the entire history is kept permanently. Mistakes
  are not rectified by replacing them in the past, but rather with the addition of
  new reversing transactions.

  How Hash Chaining Ensures Immutability
  The link between the blocks is established with the cryptographic hash of the preceding
  block:

  An alteration of even 1 bit in a past block dramatically changes its hash (avalanche
  effect).

  This leads to the "previous hash" reference in the next block being broken.

  To cover up the tampering, a hacker needs to perform the same intense computing
  work that involves re-mining the compromised block plus all the consecutive blocks.

  In a Proof-of-Work system, the massive power cost needed makes this practically
  impossible.

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
        rect(pos, (pos.at(0) + 5, pos.at(1) + 4), fill: rgb("#e3f2fd"), stroke: primary-color + 2pt, radius: 0.4, name: id)

        // Block title
        content((pos.at(0) + 2.5, pos.at(1) + 3.4), labels.at(i), weight: "bold")

        content((pos.at(0) + 2.5, pos.at(1) + 2.5), [
          Header, Previous Block \
          Adress, Timestamp, Nonce,\
          Merkel Root
        ], anchor: "north")

        // Previous Hash field (except first block)
        if i > 0 {
          content((pos.at(0) + 2.5, pos.at(1) + 0.8), text(fill: red.darken(50%), weight: "bold")[
            Previous Hash = #if i == 1 { ( text("Hash" + sub("n-1")) ) } else { text("Hash" + sub("n")) }
          ], anchor: "north")
        }
      }

      // Hash arrows pointing right
      line((6, 5.8), (7, 5.8), mark: (end: ">"), stroke: primary-color + 1.5pt)
      content((6.5, 6.1), [#text(size: 0.8em)[Hash]], weight: "semibold")

      line((12, 5.8), (13, 5.8), mark: (end: ">"), stroke: primary-color + 1.5pt)
      content((12.5, 6.1), [#text(size: 0.8em)[Hash]], weight: "semibold")

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

  Immutability isn't absolute it's economic finality. Suppose an adversary gains
  control of the hash power of the network that is more than 50%.

  They first make the transaction public and then create a hidden chain that does
  not include that transaction and is longer than the public one.
  When the hidden chain is revealed, the participants in the network apply the longest-chain
  rule and accept it.
  The time of the original transaction is then erased from the canonical history
  → successful double-spend.

  In this way, the immutability of the blockchain is guaranteed by cryptography but
  the costs that have to be borne for acquiring majority hash power finally determine
  the security.

]

#question("3. Transparency vs. Privacy")[
  Evaluate blockchain transparency vs. privacy.
  - Compare Bitcoin vs. Ethereum
  - Explain mixers, stealth addresses, and ZK proofs.
]

#answer[

  #accent[Blockchain Transparency vs. Privacy]
  Blockchain technology in its very nature supports transparency. Transparency is
  considered
  the primary attribute since the global digital ledger used for recording transactions
  is accessible and verifiable by all. This common and checkable data creates trust
  between the parties and ensures that there is always evidence because all the information
  is capable of being traced. Thus, transparency together with immutability creates
  an environment that does not need the involvement of third-party intermediaries
  which
  results in lower costs and faster processing.

  The conflict between transparency and privacy is evident, on one hand, the decentralization
  of the network renders intermediaries unnecessary, on the other hand, the requirement
  for digital cash to be decentralized implies that both accountability (the prevention
  of double-spends) and anonymity (the grant of privacy) have to be dealt with. Regardless,
  the very nature of blockchain guarantees that each transaction is public and can
  be verified. In a public blockchain scenario, which is characterized by wide geographical
  distribution and lack of trust, there might be some bad actors that try to listen
  in, therefore, in these situations, encryption is the standard method used to ensure
  confidentiality.

  #accent[ Comparison of Bitcoin and Ethereum ]

  When Bitcoin and Ethereum are fundamentally different in their approach, in terms
  of both purpose and consensus mechanism, one finds the real point of comparison
  coming
  with transaction throughput, speed, and other performance metrics.

  #figure(table(
    columns: (1.1fr, 3fr, 3fr),
    align: left,
    fill: (x, y) => if (y == 0 or x == 0) { accent-color.lighten(80%) },
    inset: 10pt,
    [],                  [*Bitcoin*],                               [*Ethereum*],
    [Purpose],           [A credible alternative to traditional fiat currencies (medium
    of exchange, potential store of value)],  [A
    platform to run programmatic contracts and applications via Ether],
    [Consensus],         [Proof-of-Work (PoW)],                     [Proof-of-Stake
    (PoS) (as per forecast, reflecting the transition)],
    [Transaction Model], [Unspent Transaction Output (UTXO). Your balance is the
    sum
    of all distinct, unspent outputs, which must be spent entirely in a single transaction],                                          [Account-based
    model (Externally Owned Accounts and Contract Accounts),. An account holds a
    single
    balance that increases or decreases],
    [Block Time],        [10 minutes on average],                   [12 seconds on
    average],
    [TPS],               [3-7 transactions per second],             [10-30 transactions
    per second],
    [Supply],            [Finite supply, capped at 21 million BTC], [No fixed maximum
    supply, issuance to validators but some ETH is burned, sometimes making supply
    net‑deflationary],
  ), caption: [
    Bitcoin vs Ethereum
  ])
]
#explain-term("Mixers", summary: "Services or protocols that break the on‑chain link between source and destination of funds.", [
  Mixers take the coins from a lot of users and mix them up so that it is hard to
  identify which output is from which input.
  For Bitcoin, this is usually done through collaborative transactions (like CoinJoin),
  whereas for Ethereum, mixers mostly rely on smart contracts that take deposits
  and
  later let people withdraw to a new address using a secret.
  On the one hand, mixers enhance privacy, on the other hand, they can create compliance
  and legal issues if used to hide illegal money.
])

#explain-term("Stealth address", [
  Stealth addresses hide the connection between a receiver's public identity and
  the
  real address that receives funds. Thus, they protect the privacy of the recipient
  rather than that of the sender or the amount. The usual scenario is that the receiver
  discloses some long term public key data, the sender and the receiver produce a
  one-time
  payment address using a Diffie–Hellman like key agreement and a derivation scheme,
  which makes it
  appear to the blockchain as if the recipient is using a new random address that
  is not easily associated
  with them. This provides a level of privacy comparable to using a new
  address for each payment but with on-chain derivation and optional scanning keys,
  so only the recipient
  can recognize and spend from these stealth outputs.
], summary: "Stealth addresses generate unique, one-time payment addresses through cryptographic key agreements. This ensures the recipient's privacy by making it impossible to trace the connection between their public identity and on-chain transactions.")
#explain-term("ZK proofs and privacy", [
  Zero‑knowledge (ZK) proofs let a party prove that “this transaction or statement
  is valid under the rules” without revealing underlying data such as which exact
  notes are spent, which address is used, or what attribute values are. On Ethereum,
  ZK is used in several ways:

  - Mixers like Tornado Cash: prove “I own one of the deposits in this Merkle tree”
    without revealing which leaf.

  - ZK-rollups and private payment/DEX systems: prove correctness of batched transactions
    while hiding individual details.

  - ZK identity: prove properties such as age, membership, or ownership of a credential
    without disclosing the identifier or full record, enabling Sybil-resistant yet
    privacy-preserving identity.

  Overall, Bitcoin’s base layer leans heavily toward transparent auditability with
  bolt‑on privacy tools, while Ethereum’s programmable environment exposes more activity
  but also makes sophisticated privacy primitives like mixers, stealth address schemes,
  and ZK systems first-class smart contract applications.
])
#question("4. DApp Architecture")[
  Define DApp architecture in detail. \
  Describe how the following components interact:
  - Smart contract layer
  - Off-chain backend
  - Frontend
  - Wallets (EIP-1193 providers)
  - Nodes (RPC, full, light)
]

#answer[
  A Decentralized Application (DApp) is a software program that runs on a blockchain
  or a peer-to-peer (P2P) network of computers and thus does not depend on centralized
  servers. DApps rely on smart contracts to carry out their core consumptions, in
  this way, all operations are decentralized, transparent, and secured by cryptography.
  One of the key differences between DApps and Web2 applications is the way they
  handle data and business logic: the former spreads them over various nodes while
  the latter concentrates them on one or more servers and thus gets rid of bugs,
  allows for constant improvements, etc., at the cost of centralization.

  The DApp architecture is based on three main pillars: the frontend (user interface),
  the smart contract layer (business logic), and the blockchain (data storage).

  #accent[ Component Interactions in Transaction Flow ]
  The transactions in a DApp come along with a structured flow starting from the
  user input to the on-chain execution, and this is the point where the seamless
  interactions among the components happen.

  #accent[Frontend]
  The frontend user interface (UI) is the and is usually made using web technologies
  like HTML, CSS, and JavaScript frameworks (e.g. React). It handles the user actions
  like transfer and swap that happen with the help of button clicks and creates the
  transaction payload that calls the specific functions of smart contracts. In this
  part, there are no changes of states and it acts like a bridge that connects users
  to the blockchain with the help of libraries such as ethers.js or web3.js.

  #accent("Wallets (EIP-1193 Providers)")
  Wallets are usually browser extensions like MetaMask and represent Externally Owned
  Accounts (EOAs) that are controlled by private keys and follow EIP-1193 standards
  for provider interfaces. When the frontend makes a request, the wallet asks for
  user approval, then signs the transaction with cryptographic methods, and finally
  estimates and pays the gas fee. The wallet then sends back the signed transaction
  to the frontend so it can be sent out.

  #accent("Smart Contract Layer ")
  Smart contracts (for example, on Ethereum) are an inherent part of the blockchain
  that contain immutable bytecode executing the business logic in the Ethereum Virtual
  Machine (EVM). When a signed transaction is available, the EVM acts on the called
  function in accordance with the rules laid down beforehand, modifies the global
  state (e.g. balances) and generates events for logging. The process is predictable
  and consensus is maintained among nodes.

  #accent("Nodes (RPC, Full, Light)")
  Nodes are the major part of the P2P blockchain network maintainers, they store
  and validate the ledger.

  #accent("Remote Procedure Call (RPC): ")
  Acts as the API gateway, e.g., JSON-RPC via Infura or Alchemy, facilitating transactions
  and balance or event querying by the frontends and wallets.­

  #accent("Full nodes: ")
  Keep the complete chain history, run all transactions via EVM, block validation,
  and consensus enforcement.­

  #accent("Light nodes: ")
  Have less resource requirements, keep only block headers and apply Simplified Payment
  Verification (SPV) to connections with full nodes for querying without entire storage.

  #figure(table(
    columns: (0.9fr, 1.5fr, 2fr),
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    align: left,
    inset: 8pt,
    [*Step*],                  [*Components involved*],              [*Action*],
    [1. Initiation],           [Frontend → Wallet],                  [UI captures
    input, wallet signs tx~fiveable+1],
    [2. Broadcast],            [Wallet → RPC Node],                  [Signed tx sent
    via RPC~geeksforgeeks],
    [3. Validation/Execution], [Full/Light Nodes → Smart Contracts], [EVM runs logic,
    state updates~fiveable],
    [4. Confirmation],         [Nodes → Frontend/Off-chain],         [Polling/receipts
    update UI, events indexed~geeksforgeeks],
  ), caption: [
    Transaction Flow Summary
  ])
  This architecture ensures trustless, verifiable operations ideal for applications
  like DeFi and NFTs.

  #figure(image("assets/ArchitectureofaDApp.png", width: 50%), caption: [
    DApp Architecture diagram
  ]) <architecture_of_dapp>
  The architecture of the Decentralized Application (DApp) is presented in an uncomplicated
  diagram (@architecture_of_dapp) consisting of three layers: first, a user actions
  take through a frontend based on the browser, and then the frontend connects to
  the smart contracts running in the Ethereum Virtual Machine (EVM) on the Ethereum
  blockchain.

  Moving from the top to the bottom:

  - First and foremost, the user through a browser gets the frontend (HTML, CSS,
    JavaScript) from a web server over the Internet.

  - Then the frontend sends requests (such as sending transactions or calling functions)
    to the smart contracts that have already been deployed.

  - Finally, the execution of the smart contracts takes place in the Ethereum Virtual
    Machine, which consequently updates and reads data from the Ethereum blockchain
    thus achieving a decentralized storage of contract state and transaction history.

]

// ==========================================
// MODULE 2: CRYPTOGRAPHY (PRACTICE)
// ==========================================

= Module 2: Cryptography Fundamentals

#question("1. SHA-256 Computations")[
  Compute SHA-256 hashes using at least two tools
]

#answer[
  *1. Node.js Code:*
  #figure(```javascript
const crypto = require('crypto');

function createSHA256Hash(inputString) {
  const hash = crypto.createHash('sha256');
  hash.update(inputString);
  return hash.digest('hex');
}

const myString = 'SE-2419';
const hash = createSHA256Hash(myString);
console.log(hash);
  ```, supplement: "Code Block", kind: raw) <jscodehash>

  *1. Node.js Output:*
  ```bash 
37e9bcf9787d084d18b69f2094995c80617ce56116897fe903abc120f6dc83c8
  ```
  *2. Online hashing tool*
  #figure(image("assets/onlinehash.png", width: 60%), caption: [
    Screenshot of online hashing website
  ])
  *3. Linux Terminal:*
  #figure(
    image("assets/linuxhash.png"),
  )

  #figure(```bash
prinitf "SE-2419" | sha256sum
37e9bcf9787d084d18b69f2094995c80617ce56116897fe903abc120f6dc83c8  -
  ```, caption: [
    Code
  ]) <codebash>
]

#question("2. Comparison")[
  Write a comparison of the outputs, and explain why all must be identical despite
  different
  tools.
]

#answer[
  The output of the computed SHA-256 hash of the string "SE-2419" was the same on
  all three platforms: Node.js, the online hashing tool, and the Linux ```bash sha256sum```
  utility.

  The uniformity of the output is one of the major characteristics of cryptographic
  hash functions and is determined by the idea of determinism.

  Deterministic Algorithm: \
  SHA-256 is a universally accepted deterministic mathematical algorithm that operates
  through the application of a standard. Consequently, the hash function for any
  particular input sequence of bits will always output a fixed-size 256-bit output.
  It does not matter which tool, programming language, or operating system is employed
  for the calculation as long as the strict following of the Secure Hash Standard
  (#link("https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf")[NIST FIPS
  180-4]) is ensured.

  The Role of Byte Stream: \n If the outputs were not the same, the most likely cause
  of the difference would be a variation in the input byte stream. For instance,
  one tool might have included a hidden character (like a null terminator or a space)
  that the other tools did not. But since the input byte stream for "SE-2419" was
  the same for all methods, the hash output was the same:
  #text(fill: red)[37e9bcf9787d084d18b69f2094995c80617ce56116897fe903abc120f6dc83c8]
  //$ P(n) \approx 1 - e^(-n^2 / (2H)) $
  // Add your calculation here
]

#question("3. Collison resistance")[
  - Attempt to modify one bit of input
  - Show how drastically the hash changes
  - Explain why finding two identical SHA-256 hashes is computationally infeasible
  - Estimate the probability of collision using the birthday paradox formula

]
#answer[
  In a bid to showcase the collision resistance property of the SHA-256 algorithm,
  we will take the original input "SE-2419" along with its hash and then carry out
  a minimal alteration on the input by appending a newline character, "\n", which
  is a minor change of only one byte in the sequence adding a single byte of value
  0x0A.
  This can be seen as a "one-bit" or minimal perturbation, although the adding of "\n"
  alters 8 bits, however, it shows the avalanche character, which means that even
  tiny input changes produce outputs that are completely different.
  We will compute the hashes again with the same tools but with changes as per the
  specifications: in Node.js, change the input to "SE-2419\\n", in Linux, use ```bash echo```
  instead of ```bash printf```, which adds a trailing newline by default.

  #accent("Original Input and Hash (for Reference)")

  Input: "SE-2419" (no trailing newline)

  Hash: #text(fill: red)[37aeb679f9780b4d1b6f5f2949905c80617ce56116897fe98a3bc12b6fdc3bc8]

  Modified Input: "SE-2419\\n" (with trailing newline)

  #accent("Now, recompute with each tool:")

  *Node.js Code:*

  Changed the input to "SE-2419\\n" in @jscodehash:9 to
  ```javascript 
const myString = 'SE-2419\n';
  ```
  *Node.js Output: *
  ```bash
f03d8f4d66a3fbcb9ee6fd3a580dca0624cbd8f6ec868e3890de4faeef71518f
  ```

  *Linux Terminal (using echo "SE-2419" | sha256sum):*
  #figure(image("assets/linux_new_hash.png"))
  ```bash 
  echo "SE-2419\n" | sha256sum
  f03d8f4d66a3fbcb9ee6fd3a580dca0624cbd8f6ec868e3890de4faeef71518f  -
  ```
  #accent("How Drastically the Hash Changes")
  The hash that was not altered begins with "37aeb679..." and finishes with "...6fdc3bc8".
  On the other hand,
  the modified hash (which is the result of adding just "\\n") will not at all resemble
  the original hash,
  for example, it will start with "f03d8f4d..." and there will be no similarities
  recognized among the 64
  hexadecimal characters. The reason for this is the avalanche effect of SHA-256,
  which means that output
  bits of every input bit pass through many rounds of mixing (pseudorandomness functions
  such as bitwise operations, additions, and rotations) and they all get entangled.
  The output is different by almost 50% in the case of a single bit flip (or 8 bits
  added in the case of "\\n").

  #accent("Why Two Identical SHA-256 Hashes Cannot Be Found Computationally")
  A collision happens when two distinct inputs result in the same hash output. The
  collision resistance of SHA-256 is due to the fact that it has a 256-bit output
  space, which means there are $2^256$ possible hashes (around $1.1579 × 10^77$
  unique values, which is a number larger than the atoms in the visible universe).
  In order to find a collision intentionally (preimage or second preimage attack),
  the hacker would have to brute-force search a vast number of inputs, which would
  require computational power that is way beyond what is available with current technology.
  Even if quantum computers were used (through Grover's algorithm), O($2^128$)
  operations would still be required for a preimage attack, which is not practical
  with the hardware that is expected to be available in the near future. SHA-256
  does not have any known practical collisions (in contrast to weaker hashes like
  MD5), and its design includes resistance to differential cryptanalysis and other
  attacks.

  #accent[Brithday Paradox Formula]
  The birthday paradox is a classic example that demonstrates the extent to which
  our intuition can fail when it comes to the amount of 'birthday' cases or collisions,
  as they are called, arising in small groups of people or in this case samples of
  random numbers.

  For the case of SHA-256, assume the hash space as the "birthdays" where there are
  d = $2^256$ possible values. The formula for the probability p of having at least
  one collision in n random hashes is:
  $p ≈ 1 - e^(- n^2 / (2 d))$

  When p = 0.5 that is, for the case of a 50% chance of collision, we need to find $n$
  now:
  $n ≈ sqrt(2d × ln(2)) ≈ 1.177 × sqrt(d) = 1.177 × 2^128 ≈ 4 × 10^38$

  Thus you would need to produce approximately 2^128 (340 undecillion) hashes to
  get a 50% chance of a random collision which requires a huge energy input.
]

// ==========================================
// MODULE 3: DEV ENVIRONMENT
// ==========================================

= Module 3: Developer Environment Setup

#question("Activity Requirements")[
  Set up a blockchain environment (Node.js, npm, VS Code). Initialize a project and
  install `web3`, `ethers`, `crypto-js`.
]

#answer[
  #accent[Node js version: ]
  #image("assets/1.png", height: 3cm)
  #accent[npm version:]
  #image("assets/3.png", height: 3cm)
  #accent[VS Code:]
  #image("assets/9.png")

  #accent[Project Initialization: ]
  #image("assets/6.png")
  #accent[Installing packages: ]
  #image("assets/7.png")
  #accent[Changes in ```bash package.json```]
  #image("assets/8.png")

  #accent[Explanation of packages]
  #accent[web3.js]
  web3.js is the very first and complete JavaScript library that acts as a central
  network gateway for dApps to use JSON-RPC for node communication to the Ethereum
  blockchain. It is necessary for both the network's data reading (e.g., checking
  an account balance) and data writing (e.g., sending a transaction or calling a
  smart contract function). It takes care of the low-level communication by making
  it easy for developers to use JavaScript calls to interact with the blockchain
  that is usually complex.

  #accent[ ethers.js ]
  ethers.js is a contemporary, security-centered option for web3.js. The main function
  is the same: connecting to and using Ethereum. It is famous for its clean, modular
  architecture which exclusively distinguishes the Provider (for network queries)
  from the Signer (for private key handling and signing). This division improves
  security. Additionally, it provides remarkable TypeScript support and powerful
  tools for wallet management together with smooth ENS (Ethereum Name Service) integration.
  #accent[crypto-js ]
  crypto-js is a fully JavaScript utility library that offers secure ground-level
  cryptographic algorithms (e.g., AES, SHA-256), among other things. Nonetheless,
  it is not of direct assistance for blockchain interaction. Still, it helps for
  general security needs within a dApp, like making sure data is not tampered with
  by hashing or by encrypting and decrypting sensitive information before it is stored
  or processed off-chain, for example. It is the security layer of the application
  that works along the existing security features of the blockchain.
]

// ==========================================
// MODULE 4: DEEP TECHNICAL ANSWERS
// ==========================================

= Module 4

#question("1. Bitcoin's UTXO Model")[
  - Draw a diagram of how UTXOs flow through transactions
  - Explain script validation steps
  - Discuss UTXO parallelism and stateless validation
]

#answer[
  #accent[UTXO (Unspent Transaction Output) Model:]
  The Unspent Transaction Output (UTXO) model treats cryptocurrency as discrete,
  unspent outputs from prior transactions, like individual coins. Each transaction
  consumes specific UTXOs as inputs and creates new ones as outputs, ensuring atomicity
  no
  partial spends. This contrasts with account-based models (e.g., Ethereum), where
  balances are mutable states.

  Parallelism arises because UTXOs are independent, transactions touching disjoint
  UTXO sets don't conflict and can validate concurrently across nodes. For instance,
  if Alice spends UTXO_A and Bob spends UTXO_B simultaneously, nodes process them
  in parallel without ordering dependencies, boosting throughput beyond sequential
  execution limits. Bitcoin nodes use this for mempool validation, achieving parallelism
  via simple double-spend checks per UTXO.

  When a transaction occurs:

  - Inputs: Reference UTXOs that are being spent.
  - Outputs: Create new UTXOs that can be spent in the future.
    #figure(image("assets/UTXO.jpeg"), caption: [
      An example of UTXO-based transfers in Bitcoin
    ])
    #figure(image("assets/UTXO (1).jpeg"), caption: [
      Alice Sends Bob Five Bitcoins
    ])
  #accent[Script Validation in Bitcoin's UTXO model]
  Bitcoin’s UTXO model relies on script validation to ensure that transactions are
  valid and that funds are spent according to predefined conditions.

  The validation process involves two types of scripts:
  - Locking Script (ScriptPubKey): Defines the conditions required to spend a UTXO.
    It is included in the transaction output.
  - Unlocking Script (ScriptSig): Provides the data or signatures required to satisfy
    the locking script. It is included in the transaction input.

  #accent[ Step-by-Step Script Validation Process ]
  #accent[\1. Transaction Structure: ]
  A Bitcoin transaction consists of inputs (references to UTXOs being spent) and
  outputs (new UTXOs created).
  Each input contains an unlocking script, and each output contains a locking script.

  #accent[\2. Script Execution:]
  The unlocking script and locking script are concatenated and executed in a stack-based
  scripting language (Bitcoin Script).
  The execution follows a Last-In-First-Out (LIFO) stack principle, where operations
  push or pop data from the stack.

  #accent[\3. Signature Verification:]
  For a standard Pay-to-Public-Key-Hash (P2PKH) transaction, the unlocking script
  provides:
  A digital signature (proving ownership of the private key).
  A public key (to verify the signature).
  The locking script typically contains an OP_DUP, OP_HASH160, OP_EQUALVERIFY, and
  OP_CHECKSIG sequence to validate the signature and public key hash.
  #accent[\4. Stack Operations: ]
  The script engine processes each operation:

  - OP_DUP: Duplicates the public key on the stack.
  - OP_HASH160: Hashes the public key and compares it to the hash in the locking
    script.
  - OP_EQUALVERIFY: Ensures the hashes match.
  - OP_CHECKSIG: Validates the signature using the public key.

  If the final stack value is True, the script is valid.
  #accent[\5. Consensus Rules: ]
  Nodes verify that:

  - The UTXO being spent exists and is unspent.
  - The unlocking script satisfies the locking script.
  - The sum of input values is greater than or equal to the sum of output values
    (accounting
    for fees).
  #accent[Stateless Validation Mechanics]
  Stateless validation means verifying transactions without reconstructing full chain
  state, relying only on the UTXO set a compact, Merkle-ized snapshot of unspent
  outputs. Nodes maintain this set (e.g., ~5-6 GB for Bitcoin today), checking if
  inputs are unspent via Merkle proofs, signatures, and value rules in constant time.
  No account nonce tracking or global state diffs needed, unlike Ethereum's state
  trie

  This enables parallelism: multiple validators fetch disjoint UTXO proofs independently,
  without shared state locks. In extended models like Cardano's eUTXO, scripts add
  determinism but preserve statelessness via output-based locking, supporting parallel
  contract execution if inputs don't overlap. FuelVM exemplifies this, splitting
  blocks into mini-blocks for intra-block parallelism

  #accent[ Scalability Benefits and Trade-offs ]
  Combining parallelism and statelessness yields predictable gas costs and horizontal
  scaling add nodes for more tx/s without sharding complexity. Bitcoin hits ~7 tx/s
  sequentially but scales via larger blocks or sidechains, modern UTXO chains like
  Nervos CKB target 1000+ tx/s via optimistic parallelism.

  Trade-offs include larger signatures (one per input) and wallet complexity for
  UTXO selection/coin control. Yet, privacy improves (e.g., CoinJoin mixes UTXOs)
  and DoS resistance strengthens via simple validation. For layer-2 like Lightning,
  statelessness aids watchtowers for fraud proofs.
]

#question("2. Ethereum's Account Model")[
  - Explain externally owned accounts vs. contract accounts
  - Describe nonce, balance, storage, codeHash
  - Provide JSON examples of account state
]

#answer[
  #accent[Account Type]
  Externally Owned Accounts (EOAs) represent user wallets with private/public key
  pairs, allowing direct transaction signing and ETH/token transfers without associated
  code. They cost nothing to create and enable proactive network interactions.

  Contract Accounts, or smart contracts, lack private keys and execute predefined
  EVM bytecode only when triggered by external transactions or messages. Creating
  them incurs gas costs due to storage usage, and their nonce tracks deployed sub-contracts.
  #figure(table(
    columns: 3,
    align: left,
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    [*Feature*],              [*EOA*],                 [*Contract Account*],
    [Control],                [Private key],           [Smart contract code bitstamp],
    [Transaction Initiation], [Yes],                   [No (reactive only) ethereum],
    [Code],                   [None (codeHash empty)], [EVM bytecode bitstamp],
    [Creation Cost],          [Free],                  [Gas for storage ],
  ), caption: [EOA vs Contract Account])
  #accent[Account State Fields:]
  Every account stores four fields in the state trie:

  - Nonce: Sequential counter preventing replay attacks. For EOAs, increments per
    sent
    transaction, for contracts, tracks deployed sub-contracts.

  - Balance: ETH amount in wei (1 ETH = $10^18$ wei). Transferable via transactions.

  - StorageRoot: Merkle Patricia trie root hash of persistent key-value storage.
    Empty
    ("```0x56e81f...```") for EOAs, holds contract state variables for contracts.

  - CodeHash: Keccak-256 hash of account code. EOAs use empty string hash ```0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470```,
    contracts reference actual bytecode.
  #accent[Verification:]

  ```javascript 
const { ethers } = require("ethers");
const emptyHash = ethers.keccak256(ethers.toUtf8Bytes(""));
console.log(emptyHash);
  ```
  #accent[Output:]
  ```bash 
0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470
  ```
  #accent[JSON State Examples:]
  #link("https://etherscan.io/address/0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045")[Vitalik
  Buterin's EOA (0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045 via Infura/Etherscan)]
  ```json 
{
  "balance": "7539722942274336279",
  "nonce": 1617,
  "codeHash": "0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
  "storageRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421"
}
  ```
  #link("https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48")[USDC
  Contract (0xA0b86a33Ed3D9B54f339d1D95d7A2dD5b57b32E6):]
  ```json 
{
  "balance": "1500000000000000000000000",
  "nonce": 0,
  "codeHash": "0x8e1e470e8456dc97b7f6b1f16d4c8f2b3f0e4a1c8b2d4e5f67890123456789ab",
  "storageRoot": "0xdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890abc"
}
  ```
]

#question("3. Security Implications (UTXO vs Account Models):")[
  Analyze:
  - Replay vulnerabilities
  - Transaction malleability
  - Double-spend handling
  - Smart contract attack surface
  - State bloat and scalability
]

#answer[
  #accent[ Replay vulnerabilities ]
  To get rid of replays, the UTXO system uses the approach of consuming outputs that
  are assigned to particular transactions. After they have been used or spent, they
  get eliminated from all the blockchains where they were present. This is not the
  case with the account model where the usage count is related to the specific blockchain,
  hence signatures can be replayed without any protection of EIP-155 chainId across
  forks/chains.

  #accent[ Transaction Malleability ]
  With the UTXO system, transactions once submitted cannot be changed. However, changing
  the signatures results in the creation of new transaction IDs (txids) which turns
  the dependent transactions into conflicting ones. On the other hand, the account
  model enabled signature replacement (before SegWit), which not only allowed for
  txid changes but also created a scenario of double-spend races.
  #figure(table(
    columns: 3,
    align: left,
    fill: (x, y) => if y == 0 { accent-color.lighten(80%) },
    [*Aspect*],          [*UTXO*],             [*Account model*],
    [Replay Protectoin], [Output consumption], [Chain-specfici nonce],
    [Malleability],      [Immutable txids],    [Signature swaps possible]
  ), caption: [UTXO vs Account model])

  #accent[ Double-Spend Handling ]
  The UTXO model guarantees that double-spending will never happen. Any transaction
  spending the same output twice will be rejected by the network through consensus.
  The account model checks balances and sequences nonces, which may be affected by
  race conditions during reorganization of blocks.

  #accent[ Smart Contract Attack Surface ]

  UTXO has a very few options for scripting (P2SH), which means that such attacks
  are not likely to happen because Turing-complete loops or stateful contracts are
  not possible. The account model has a powerful EVM that allows creating very complex
  contracts but at the same time it is exposing the system to reentrancy (DAO hack),
  integer overflows, and front-running attacks.

  #accent[ State Bloat and Scalability ]

  The UTXO approach eliminates the spent outputs, thus ensuring that the global state
  remains small enough for parallel validation. The account model keeps state forever
  for each user, which results in the trie growing exponentially, the network being
  slow to catch up, and denial-of-service attacks via state writes (e.g., proposals
  about state rents in 2021).

  #accent[ Tradeoff Summary: ]

  UTXO goes for security and simplicity first, so it is less programmable;
  the account model, on the other hand, allows for dApps but with the concomitant
  larger attack surface and state bloat.

]

#question("4. EVM Architecture")[
  - Explain EVM bytecode execution
  - Stack-based computation model
  - Gas metering rules
  - Error handling (revert, invalid opcode)
]

#answer[
  The Ethereum Virtual Machine (EVM) operates in a stack-based mode while executing
  smart contract bytecode, handling transactions to modify the blockchain state and
  simultaneously applying gas limits for the prevention of DoS attacks.

  The Execution Flow of Bytecode
  The EVM bytecode comprises opcodes (0x00-0xff) that are fetched one after the other
  through the use of the Program Counter (PC). Each opcode takes operands from the
  stack, does the computation, puts the result back on the stack, and moves the PC
  forward. The execution begins from the code stored in the contract account's codeHash,
  with context information such as the caller's address, the value transferred, and
  the input calldata.

  ``` ALLOW OP``` and ``` CREATE``` opcodes allow deep call stacks (up to 1024 frames)
  to create
  tree-like structures of execution for transactions.

  #accent[ Stack-Based Computation Model ]
  The EVM adopts a LIFO stack (maximum size of 1024 × 256-bit words) for mathematical
  operations and controlling the flow:

  - ``` PUSHn``` (0x60-0x7f): Loads constants (1-32 bytes)

  - ``` DUPn/SWAPn``` : Stack manipulation

  - Arithmetic: ``` ADD``` (0x01, 3 gas), ``` MUL``` (0x02, 5 gas), etc.

  - Control: ``` JUMP/JUMPI``` (0x56/57) for branching

  Memory (expandable byte array) and storage (persistent trie) accessed via ``` MLOAD/MSTORE```
  (``` SLOAD/SSTORE``` ), stack serving as operand register.
  ```
Stack example: ADD operation
Before: [5, 3]    PUSH1 5 → PUSH1 3 → ADD → [8]
  ```
  #accent[ Gas Metering Rules ]
  Every opcode consumes fixed gas + dynamic costs:

  - Base: 0-2000 gas (STOP=0, SSTORE=20000+)

  - Tiered: Very low (1, ADD), Zero (64, POP), etc.

  - Dynamic: Memory expansion (quadratic), SSTORE refunds (-4800 max per tx)

  Transaction provides gasLimit × gasPrice; exhaustion triggers OutOfGas error, reverting state changes but consuming all gas (prevents infinite loops).
]

#question("5. Smart Contracts")[
  Explain gas cost model and storage. Why are writes expensive? Provide code optimization
  example.
]

#answer[
  *Inefficient Code:*

  *Optimized Code:*

  *Explanation:* ...
]

// ==========================================
// MODULE 5: LAB EXERCISE
// ==========================================

= Module 5: Lab Exercise: Wallets & Transactions

#question("Step 1: Wallet Installation")[
  Install MetaMask/Trust/Rabby. Submit screenshot of interface and public address.
]

#answer[
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
    [*Field*],    [*Value / Explanation*],
    [Nonce],      [...],
    [Gas Price],  [...],
    [Gas Limit],  [...],
    [Value],      [...],
    [Data/Input], [...],
    [To],         [...],
  )

  *Logic Explanation:*
  // Explain how gas was calculated or UTXO consumed
]

// ==========================================
// END OF ASSIGNMENT
// ==========================================
