# WellnessCoins

WellnessCoins is a token reward distribution smart contract for healthcare service utilization rewards, built on the Stacks blockchain using Clarity smart contract language.

## Description

WellnessCoins allows healthcare providers to reward patients with tokens for utilizing healthcare services, promoting wellness and engagement. The system incentivizes regular healthcare participation by providing tangible rewards that can be accumulated and potentially redeemed for healthcare-related benefits.

## Features

- **Fungible Token Implementation**: Complete ERC-20-like token functionality with minting, burning, and transfers
- **Healthcare Provider Management**: Authorized provider system for secure token distribution
- **Service-Based Rewards**: Configurable reward amounts for different healthcare services
- **Patient Reward Tracking**: Comprehensive tracking of individual patient reward histories
- **Secure Access Control**: Owner-only administrative functions with proper authorization checks
- **Flexible Service Configuration**: Dynamic service reward setup and modification
- **Token Economics**: Built-in supply management with minting and burning capabilities

## Technical Specifications

- **Blockchain**: Stacks
- **Language**: Clarity v2
- **Epoch**: 2.5
- **Token Name**: WellnessCoins
- **Token Symbol**: WELL
- **Decimals**: 6
- **Supply**: Dynamic (minted as rewards are distributed)

## Project Structure

```
WellnessCoins/
├── README.md
├── .gitignore
└── WellnessCoins_contract/
    ├── Clarinet.toml
    ├── package.json
    ├── contracts/
    │   └── WellnessCoins.clar
    ├── tests/
    │   └── WellnessCoins.test.ts
    ├── settings/
    │   ├── Devnet.toml
    │   ├── Mainnet.toml
    │   └── Testnet.toml
    ├── tsconfig.json
    └── vitest.config.js
```

## Installation

### Prerequisites

- [Clarinet](https://docs.hiro.co/clarinet) - Stacks development environment
- [Node.js](https://nodejs.org/) (v16 or higher)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd WellnessCoins
```

2. Navigate to the contract directory:
```bash
cd WellnessCoins_contract
```

3. Install dependencies:
```bash
npm install
```

4. Verify installation:
```bash
clarinet check
```

## Usage Examples

### Initialize the Contract

```clarity
;; Initialize with default service rewards
(contract-call? .WellnessCoins initialize)
```

### Add Healthcare Providers

```clarity
;; Add a healthcare provider (owner only)
(contract-call? .WellnessCoins add-healthcare-provider 'SP1ABCDEFGHIJKLMNOPQRSTUVWXYZ)
```

### Configure Service Rewards

```clarity
;; Set reward for a new service type
(contract-call? .WellnessCoins set-service-reward "physical-therapy" u250)
```

### Award Tokens to Patients

```clarity
;; Healthcare provider awards tokens to patient
(contract-call? .WellnessCoins award-wellness-tokens 'SP2PATIENTADDRESS "checkup")
```

### Check Balances and Rewards

```clarity
;; Check patient's token balance
(contract-call? .WellnessCoins get-balance 'SP2PATIENTADDRESS)

;; Check total rewards earned by patient
(contract-call? .WellnessCoins get-patient-total-rewards 'SP2PATIENTADDRESS)
```

## Contract Functions Documentation

### Public Functions

#### Administrative Functions (Owner Only)

- **`initialize()`**: Sets up default service rewards
- **`add-healthcare-provider(provider)`**: Authorizes a healthcare provider
- **`remove-healthcare-provider(provider)`**: Removes provider authorization
- **`set-service-reward(service, reward-amount)`**: Configures reward amount for services

#### Token Operations

- **`award-wellness-tokens(patient, service)`**: Awards tokens to patients (provider only)
- **`transfer(amount, from, to, memo)`**: Transfers tokens between accounts
- **`burn(amount, owner)`**: Burns tokens for redemption purposes

### Read-Only Functions

#### Token Information
- **`get-name()`**: Returns token name ("WellnessCoins")
- **`get-symbol()`**: Returns token symbol ("WELL")
- **`get-decimals()`**: Returns decimal places (6)
- **`get-total-supply()`**: Returns current total supply
- **`get-token-uri()`**: Returns token metadata URI

#### Balance and Reward Queries
- **`get-balance(account)`**: Returns token balance for account
- **`get-patient-total-rewards(patient)`**: Returns cumulative rewards earned
- **`get-service-reward(service)`**: Returns reward amount for service
- **`is-healthcare-provider(provider)`**: Checks provider authorization status

### Default Service Rewards

| Service | Reward Amount (WELL) |
|---------|---------------------|
| checkup | 100 |
| vaccination | 200 |
| screening | 150 |
| consultation | 75 |
| wellness-program | 300 |

## Testing

Run the test suite:

```bash
# Run all tests
npm test

# Run tests with coverage and cost analysis
npm run test:report

# Watch mode for development
npm run test:watch
```

## Deployment Guide

### Local Development (Devnet)

1. Start Clarinet console:
```bash
clarinet console
```

2. Deploy the contract:
```clarity
::deploy_contract WellnessCoins
```

3. Initialize the contract:
```clarity
(contract-call? .WellnessCoins initialize)
```

### Testnet Deployment

1. Configure testnet settings in `settings/Testnet.toml`
2. Deploy using Clarinet:
```bash
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

### Mainnet Deployment

1. Configure mainnet settings in `settings/Mainnet.toml`
2. Ensure thorough testing on testnet
3. Deploy using Clarinet:
```bash
clarinet deployments generate --mainnet
clarinet deployments apply --mainnet
```

## Security Notes

### Access Control
- **Owner Privileges**: Only contract owner can manage providers and service rewards
- **Provider Authorization**: Only authorized providers can award tokens
- **Transfer Restrictions**: Users can only transfer their own tokens (or owner can transfer any)

### Error Codes
- `u100`: ERR-OWNER-ONLY - Function restricted to contract owner
- `u101`: ERR-NOT-AUTHORIZED - Caller not authorized for this operation
- `u102`: ERR-INSUFFICIENT-BALANCE - Insufficient token balance
- `u103`: ERR-INVALID-AMOUNT - Invalid amount specified
- `u104`: ERR-ALREADY-PROVIDER - Provider already exists
- `u105`: ERR-NOT-PROVIDER - Provider not found
- `u106`: ERR-INVALID-SERVICE - Service not configured

### Best Practices
1. **Provider Management**: Regularly audit authorized healthcare providers
2. **Service Configuration**: Monitor reward amounts to prevent inflation
3. **Token Economics**: Consider implementing reward caps or decay mechanisms
4. **Access Logging**: Monitor contract interactions for unusual patterns
5. **Regular Audits**: Conduct periodic security reviews of provider activities

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add comprehensive tests
5. Submit a pull request

## License

This project is licensed under the ISC License.

## Support

For questions and support, please open an issue in the repository or contact the development team.

---

**Note**: This smart contract is designed for healthcare token rewards. Ensure compliance with relevant healthcare regulations and token regulations in your jurisdiction before deployment.