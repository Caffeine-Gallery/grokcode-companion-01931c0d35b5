# Deployment Instructions

This README provides instructions on how to deploy your canister to different environments using `dfx`.

## Prerequisites

- Ensure you have `dfx` installed and configured.
- Navigate to your project directory in the terminal.
- Verify that the canisters you want to deploy are configured in the project's `dfx.json` file.

## Deployment Options

### Local Deployment

1. Start the local canister execution environment:
   ```
   dfx start
   ```

2. Deploy locally:
   ```
   dfx deploy
   ```

### Deploying to Playground

To deploy to the playground environment:
```
dfx deploy --playground
```

### Deploying to Mainnet

To deploy to the mainnet:
```
dfx deploy --network ic
```

**Note:** Deploying canisters to the mainnet will cost cycles. Make sure you have acquired the necessary cycles before deployment.

### Deploying Specific Canisters

To deploy a specific canister, use the canister's name:

- Local deployment:
  ```
  dfx deploy <canister_name>
  ```

- Playground deployment:
  ```
  dfx deploy <canister_name> --playground
  ```

- Mainnet deployment:
  ```
  dfx deploy <canister_name> --network ic
  ```

Example:
```
dfx deploy hello_backend
dfx deploy hello_backend --playground
dfx deploy hello_backend --network ic
```

## Additional Resources

- For creating a new project, check out the ["Hello, world!"](https://internetcomputer.org/docs/current/developer-docs/getting-started/hello-world) sample project.
- [Learn more](https://internetcomputer.org/docs/current/developer-docs/getting-started/cycles/cycles-faucet) about cycles and how to acquire them for mainnet deployment.

