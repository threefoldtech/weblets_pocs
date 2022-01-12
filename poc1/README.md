# POC1 - pkid

Implements the threefold login SDK and the pkid SDK.

## About The Project
Vue app that interacts with jimber api to store a key/value and retrieve by key

### Built With

* [Vue.js](https://vuejs.org/)
* [jimber/pkid](https://github.com/threefoldtech/pkid-node-client)
  
<!-- GETTING STARTED -->
## Getting Started
POC implements the threefold login SDK and the pkid SDK.
After login there will be a variable in localStorage named profile that has user derived seed.
from that seed we get the keypair (public, private keys)
using the pkid lib then we use the client to set and get the values

### Prerequisites

* yarn
  ```sh
  npm install -g yarn
  ```
* threefold connect mobile app (make sure to create an account)

### Installation


1. Clone the repo
   ```sh
   git clone https://github.com/threefoldtech/weblets_pocs.git
   ```
2. Install NPM packages
   ```sh
   yarn install
   ```
3. start the Vue app
   ```sh
   yarn dev;
   ```
   or if you want to build and serve your dist
    ```sh
    yarn build
    yarn serve
    ```

## Usage
1. using the threefold connect mobile app, create new threefold account if you don't have one.
2. make sure that Vue app have been started and navigate in your browser to https://localhost:3000
3. click on the threefold logo button, and complete the login flow using your threefold connect mobile app.
4. there are two supported functions, set and get. from UI, you can enter a key and a value and press `Add or Update Key` button to add new or update an existing key. or you can enter an existing key and press `Get Value` button to retrieve and display the value.

## Acknowledgments

this example is a modified version of [threefoldtech/threefold_login_pkid_example](https://github.com/threefoldtech/threefold_login_pkid_example)