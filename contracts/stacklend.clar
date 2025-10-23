;; ------------------------------------------------------------
;; Replaced em-dash with regular hyphen
;; StackLend - Decentralized Micro-Lending Vault
;; ------------------------------------------------------------
;; A simple and transparent STX lending contract on Stacks
;; ------------------------------------------------------------
;; Developed by: [Your Name]
;; ------------------------------------------------------------

(define-constant ERR_NOT_FOUND (err u100))
(define-constant ERR_UNAUTHORIZED (err u101))
(define-constant ERR_ALREADY_REPAID (err u102))
(define-constant ERR_NOT_EXPIRED (err u103))
(define-constant ERR_INSUFFICIENT_FUNDS (err u104))

(define-data-var loan-counter uint u0)

;; Structure for each loan record
(define-map loans
  {id: uint}
  {
    lender: principal,
    borrower: principal,
    amount: uint,
    interest: uint,
    collateral: uint,
    start-block: uint,
    duration: uint,
    repaid: bool,
    active: bool
  }
)

;; Removed define-event lines - Clarity uses print for events

;; Create a loan offer (only lender)
(define-public (create-loan-offer (amount uint) (interest uint) (duration uint))
  (let ((new-id (+ u1 (var-get loan-counter))))
    (begin
      (map-set loans
        {id: new-id}
        {
          lender: tx-sender,
          borrower: tx-sender,
          amount: amount,
          interest: interest,
          collateral: u0,
          start-block: u0,
          duration: duration,
          repaid: false,
          active: true
        })
      (var-set loan-counter new-id)
      ;; Replaced emit-event with print
      (print {event: "loan-offer", loan-id: new-id, lender: tx-sender, amount: amount, interest: interest})
      (ok new-id)
    )
  )
)

;; Request an existing loan offer (borrower locks collateral)
(define-public (request-loan (loan-id uint) (collateral uint))
  (let ((loan (map-get? loans {id: loan-id})))
    (match loan
      loan-data
      (begin
        ;; Transfer collateral from borrower to contract
        (try! (stx-transfer? collateral tx-sender (as-contract tx-sender)))
        (map-set loans {id: loan-id}
          (merge loan-data {
            borrower: tx-sender,
            collateral: collateral,
            start-block: stacks-block-height
          })
        )
        ;; Transfer loan amount from lender to borrower
        (try! (stx-transfer? (get amount loan-data) (get lender loan-data) tx-sender))
        ;; Replaced emit-event with print
        (print {event: "loan-requested", loan-id: loan-id, borrower: tx-sender, collateral: collateral})
        (ok "Loan successfully requested")
      )
      ERR_NOT_FOUND
    )
  )
)

;; Repay loan with interest
(define-public (repay-loan (loan-id uint))
  (let ((loan (map-get? loans {id: loan-id})))
    (match loan
      loan-data
      (if (and (is-eq tx-sender (get borrower loan-data)) (not (get repaid loan-data)))
          (let ((total (+ (get amount loan-data) (get interest loan-data))))
            (try! (stx-transfer? total tx-sender (get lender loan-data)))
            ;; Return collateral
            (try! (stx-transfer? (get collateral loan-data) (as-contract tx-sender) tx-sender))
            (map-set loans {id: loan-id} (merge loan-data {repaid: true, active: false}))
            ;; Replaced emit-event with print
            (print {event: "loan-repaid", loan-id: loan-id, borrower: tx-sender, total: total})
            (ok "Loan repaid successfully")
          )
          ERR_UNAUTHORIZED
      )
      ERR_NOT_FOUND
    )
  )
)

;; Liquidate loan (claim collateral if overdue)
(define-public (liquidate-loan (loan-id uint))
  (let ((loan (map-get? loans {id: loan-id})))
    (match loan
      loan-data
      (if (and (is-eq tx-sender (get lender loan-data)) (>= (- stacks-block-height (get start-block loan-data)) (get duration loan-data)) (not (get repaid loan-data)))
          (begin
            (try! (stx-transfer? (get collateral loan-data) (as-contract tx-sender) (get lender loan-data)))
            (map-set loans {id: loan-id} (merge loan-data {active: false}))
            ;; Replaced emit-event with print
            (print {event: "loan-liquidated", loan-id: loan-id, lender: tx-sender, collateral: (get collateral loan-data)})
            (ok "Loan liquidated - collateral claimed")
          )
          ERR_NOT_EXPIRED
      )
      ERR_NOT_FOUND
    )
  )
)

;; View loan details
(define-read-only (get-loan (loan-id uint))
  (ok (map-get? loans {id: loan-id}))
)
