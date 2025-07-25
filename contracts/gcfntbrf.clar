;; Governance contract for managing the blockchain relief fund


;; =========================================
;; Data variables
;; =========================================


(define-data-var admin principal tx-sender)        ;; Admin who has special privileges
(define-data-var min-donation uint u10)            ;; Minimum donation required
(define-data-var withdrawal-limit uint u1000)      ;; Max withdrawal per recipient


;; =========================================
;; CORE FUNCTIONS
;; =========================================


;; Function to set a new admin (only callable by the current admin)
(define-public (set-admin (new-admin principal))
 (let ((current-admin (var-get admin)))
   (if (and
         (is-eq tx-sender current-admin)
         (not (is-eq new-admin current-admin))
         (not (is-eq new-admin 'SP000000000000000000002Q6VF78))) ;; Example: Prevent setting to zero address
     (begin
       (var-set admin new-admin)
       (ok new-admin)
     )
     (err u401) ;; Error: Invalid admin change request
   )
 )
)


;; Function to update the minimum donation amount
(define-public (set-min-donation (amount uint))
 (if (is-eq tx-sender (var-get admin))
   (if (> amount u0)
     (begin
       (var-set min-donation amount)
       (ok amount)
     )
     (err u402) ;; Error: Invalid donation amount
 )
   (err u401) ;; Error: Only admin can call this function
 )
)
