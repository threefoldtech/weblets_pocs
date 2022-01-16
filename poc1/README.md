# POC1 - pkid

Implements the threefold login SDK and the pkid SDK.

## About The Project

Vue app that interacts with jimber api to store a key/value pair and retrieve by key

![Screenshot from 2022-01-13 12-28-58](https://user-images.githubusercontent.com/42457449/149313211-a250f25a-4739-43e2-80b3-246c7a7b877d.png)

### Built With

-   [Vue.js](https://vuejs.org/)
-   [jimber/pkid](https://github.com/threefoldtech/pkid-node-client)

<!-- GETTING STARTED -->

## Getting Started

this is a POC implements the threefold login SDK and the pkid SDK.
After login there will be a variable in localStorage named profile that has user derived seed.
from that seed we get the keypair (public, private keys)
then with the help of the pkid lib the app allow the user to store and retrieve data from the jimper PKID.

[PKID](https://github.com/threefoldtech/pkid) is a public Key Indexed Datastore. You can save plain or encrypted data in a public key index; as long as you are the owner of the secret corresponding to that public key.

### Prerequisites

-   yarn
    ```sh
    npm install -g yarn
    ```
-   threefold connect mobile app (make sure to create an account)

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
2. make sure that Vue app have been started and navigate in your browser to https://localhost:8881
3. click on the threefold logo button, and complete the login flow using your threefold connect mobile app.
4. there are two supported functions, set and get. from UI, you can enter a key and a value and press `Add or Update Key` button to add new or update an existing key. or you can enter an existing key and press `Get Value` button to retrieve and display the value.

## Acknowledgments

this example is a modified version of [threefoldtech/threefold_login_pkid_example](https://github.com/threefoldtech/threefold_login_pkid_example)
