StackLend Smart Contract

**A Decentralized Lending and Borrowing Protocol on the Stacks Blockchain**

StackLend is a **trustless DeFi lending platform** built using **Clarity**, designed to allow users to **lend, borrow, and earn yield** directly on the **Stacks blockchain** — secured by Bitcoin.  
It leverages smart contracts to enable **peer-to-peer lending** without intermediaries, ensuring transparency, automation, and open access to decentralized credit markets.

---

Features

- **Lending Pools:** Users can deposit STX or SIP-010 tokens to earn interest.  
- **Borrowing:** Borrowers can take loans by locking collateral on-chain.  
- **Collateral Management:** Automatically enforces over-collateralization ratios for loan safety.  
- **Repayment & Liquidation:** Streamlined repayment flow and auto-liquidation of unsafe loans.  
- **Transparent On-Chain Data:** All operations, balances, and loan records are verifiable on-chain.

---

Smart Contract Overview

| Function | Description |
|-----------|--------------|
| `deposit-funds` | Allows users to deposit STX or SIP-010 tokens into the lending pool. |
| `request-loan` | Enables borrowers to open new loan positions by specifying collateral and amount. |
| `repay-loan` | Allows borrowers to repay outstanding debt and reclaim collateral. |
| `liquidate-loan` | Enables anyone to liquidate loans that fall below the safe collateral threshold. |
| `get-loan-info` | Returns loan details, including collateral, debt, and status. |

---

Technical Details

- **Language:** [Clarity](https://docs.stacks.co/write-smart-contracts/clarity-overview)  
- **Blockchain:** [Stacks](https://stacks.co/)  
- **Contract Name:** `stacklend.clar`  
- **Category:** DeFi / Lending  
- **Compatibility:** Clarinet v1.0+  

---

How It Works

1. **Lenders Deposit:** Users deposit STX or tokens into the StackLend pool.  
2. **Borrowers Request Loans:** Borrowers lock collateral and borrow a percentage of its value.  
3. **Interest Accrues:** Borrowers repay loans with added interest that goes to lenders.  
4. **Liquidation:** If collateral value drops below a safe threshold, loans are auto-liquidated.  

This ensures fairness and sustainability for both lenders and borrowers.

---

Testing

Run the following commands to check and test the contract locally using **Clarinet**:

```bash
clarinet check
clarinet test
