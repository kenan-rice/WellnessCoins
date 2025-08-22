
;; title: WellnessCoins
;; version: 1.0.0
;; summary: A token reward distribution smart contract for healthcare service utilization rewards
;; description: WellnessCoins allows healthcare providers to reward patients with tokens 
;;              for utilizing healthcare services, promoting wellness and engagement.

;; traits
;; SIP-010 trait implementation can be added when deploying to mainnet

;; token definitions
(define-fungible-token wellness-coin)

;; constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-ALREADY-PROVIDER (err u104))
(define-constant ERR-NOT-PROVIDER (err u105))
(define-constant ERR-INVALID-SERVICE (err u106))

;; data vars
(define-data-var token-name (string-ascii 32) "WellnessCoins")
(define-data-var token-symbol (string-ascii 10) "WELL")
(define-data-var token-decimals uint u6)
(define-data-var total-supply uint u0)

;; data maps
(define-map token-balances principal uint)
(define-map healthcare-providers principal bool)
(define-map service-rewards (string-ascii 50) uint)
(define-map patient-rewards principal uint)

;; public functions

;; Initialize contract with basic service rewards
(define-public (initialize)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (map-set service-rewards "checkup" u100)
    (map-set service-rewards "vaccination" u200)
    (map-set service-rewards "screening" u150)
    (map-set service-rewards "consultation" u75)
    (map-set service-rewards "wellness-program" u300)
    (ok true)
  )
)

;; Add a healthcare provider
(define-public (add-healthcare-provider (provider principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (not (default-to false (map-get? healthcare-providers provider))) ERR-ALREADY-PROVIDER)
    (map-set healthcare-providers provider true)
    (ok true)
  )
)

;; Remove a healthcare provider
(define-public (remove-healthcare-provider (provider principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (default-to false (map-get? healthcare-providers provider)) ERR-NOT-PROVIDER)
    (map-delete healthcare-providers provider)
    (ok true)
  )
)

;; Set reward amount for a specific service
(define-public (set-service-reward (service (string-ascii 50)) (reward-amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (> reward-amount u0) ERR-INVALID-AMOUNT)
    (map-set service-rewards service reward-amount)
    (ok true)
  )
)

;; Award tokens to a patient for utilizing a healthcare service
(define-public (award-wellness-tokens (patient principal) (service (string-ascii 50)))
  (let
    (
      (provider-authorized (default-to false (map-get? healthcare-providers tx-sender)))
      (reward-amount (default-to u0 (map-get? service-rewards service)))
      (current-balance (default-to u0 (map-get? token-balances patient)))
      (current-patient-rewards (default-to u0 (map-get? patient-rewards patient)))
    )
    (asserts! provider-authorized ERR-NOT-AUTHORIZED)
    (asserts! (> reward-amount u0) ERR-INVALID-SERVICE)
    
    ;; Mint tokens and update balances
    (try! (ft-mint? wellness-coin reward-amount patient))
    (map-set token-balances patient (+ current-balance reward-amount))
    (map-set patient-rewards patient (+ current-patient-rewards reward-amount))
    (var-set total-supply (+ (var-get total-supply) reward-amount))
    
    (ok reward-amount)
  )
)

;; Transfer tokens between accounts
(define-public (transfer (amount uint) (from principal) (to principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq from tx-sender) (is-eq from CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (<= amount (get-balance from)) ERR-INSUFFICIENT-BALANCE)
    
    (try! (ft-transfer? wellness-coin amount from to))
    (map-set token-balances from (- (get-balance from) amount))
    (map-set token-balances to (+ (get-balance to) amount))
    
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

;; Burn tokens (for redemption purposes)
(define-public (burn (amount uint) (owner principal))
  (begin
    (asserts! (is-eq tx-sender owner) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (<= amount (get-balance owner)) ERR-INSUFFICIENT-BALANCE)
    
    (try! (ft-burn? wellness-coin amount owner))
    (map-set token-balances owner (- (get-balance owner) amount))
    (var-set total-supply (- (var-get total-supply) amount))
    
    (ok true)
  )
)

;; read only functions

;; Get token name
(define-read-only (get-name)
  (ok (var-get token-name))
)

;; Get token symbol
(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

;; Get token decimals
(define-read-only (get-decimals)
  (ok (var-get token-decimals))
)

;; Get total supply
(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

;; Get token URI
(define-read-only (get-token-uri)
  (ok none)
)

;; Get balance of an account
(define-read-only (get-balance (account principal))
  (default-to u0 (map-get? token-balances account))
)

;; Check if an address is a healthcare provider
(define-read-only (is-healthcare-provider (provider principal))
  (default-to false (map-get? healthcare-providers provider))
)

;; Get reward amount for a service
(define-read-only (get-service-reward (service (string-ascii 50)))
  (default-to u0 (map-get? service-rewards service))
)

;; Get total rewards earned by a patient
(define-read-only (get-patient-total-rewards (patient principal))
  (default-to u0 (map-get? patient-rewards patient))
)

;; private functions

;; Helper function to safely get balance
(define-private (safe-get-balance (account principal))
  (default-to u0 (map-get? token-balances account))
)
