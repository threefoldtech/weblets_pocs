<svelte:options tag="tf-vserver" />

<script lang="ts">
  import type { HTTPMessageBusClient } from "ts-rmb-http-client";

  const { HTTPMessageBusClient } = window.$libs.ts_rmb_http_client;
  let command: string = "";
  let payload: string = "{}";
  let twinId: number = 0;
  let mnemonics: string = "";
  let secret: string = "";
  let envs: string[] = ["dev", "test", "main"];
  let selectedEnv: string;
  let isConfigReady: boolean = false;
  let isLaunched: boolean = false;
  let skipLaunch: boolean = false;
  let isReady: boolean = false;
  let gridProxyUrls = {
    dev: "https://gridproxy.dev.grid.tf",
    test: "https://gridproxy.test.grid.tf",
    main: "https://gridproxy.grid.tf",
  };
  let responseLaunchError;
  let responseLaunchData;
  let responseError;
  let responseData;
  let illustrationMsg: string;
  let rmb: HTTPMessageBusClient;

  $: {
    if (skipLaunch) {
      isReady = twinId !== 0 && command ? true : false;
      if (twinId === 0) {
        illustrationMsg = "Add your twin id";
      } else if (!command) {
        illustrationMsg = "Add command to your message";
      } else {
        illustrationMsg = "";
      }
    } else if (isLaunched && !command) {
      isReady = false;
      illustrationMsg = "Add command to your message";
    } else if (!isLaunched) {
      isReady = false;
      if (twinId === 0 || !mnemonics || !secret) {
        isConfigReady = false;
        illustrationMsg = "Complete your configurations";
      } else {
        isConfigReady = true;
        illustrationMsg =
          "Launch your twinserver or check skip if you do it before";
      }
    } else {
      isReady = true;
      illustrationMsg = "";
    }
    rmb = new HTTPMessageBusClient(twinId, gridProxyUrls[selectedEnv]);
  }

  const onLaunch = async () => {
    let msg = rmb.prepare("vserver.launch_twinserver", [twinId], 0, 2);
    const message = await rmb.send(
      msg,
      `{"network" : "${selectedEnv}", "mnemonic" : "${mnemonics}", "storeSecret" : "${secret}"}`
    );
    const launchResult = await rmb.read(message);
    responseLaunchError = launchResult[0].err ? launchResult[0].err : "";
    responseLaunchData = JSON.parse(launchResult[0].dat as string);
    isLaunched = responseLaunchData["success"] ? true : false;
  };

  const onSend = async () => {
    if (command.includes("twinserver")) {
      command = command.replaceAll("twinserver", "vserver");
    } else if (!command.startsWith("vserver")) {
      command = "vserver." + command;
    }
    let msg = rmb.prepare(command, [twinId], 0, 2);
    const message = await rmb.send(msg, payload);
    const result = await rmb.read(message);
    if (result.length > 0) {
      responseError = result[0].err ? result[0].err : "";
      responseData = result[0].dat
        ? JSON.stringify(JSON.parse(result[0].dat as string), undefined, 2)
        : "";
    } else {
      responseError = "Unknown Command";
    }
  };
</script>

<div class="twinclient">
  <h1>Twin Client Weblet</h1>
  <div class="section">
    <h2>Configurations</h2>
    <div class="section__element">
      <p class="label">Network Environment</p>
      <select bind:value={selectedEnv}>
        {#each envs as env}
          <option value={env}>{env}</option>
        {/each}
      </select>
    </div>
    <div class="section__element">
      <p class="label">Twin Id</p>
      <input
        type="number"
        value={twinId}
        on:change={(e) => {
          twinId = +e.target["value"];
        }}
      />
    </div>
    <div class="section__element">
      <p class="label">Mnemonics</p>
      <input
        type="password"
        value={mnemonics}
        on:change={(e) => {
          mnemonics = e.target["value"];
        }}
      />
    </div>
    <div class="section__element">
      <p class="label">KVStore Secret</p>
      <input
        type="password"
        value={secret}
        on:change={(e) => {
          secret = e.target["value"];
        }}
      />
    </div>
    <div class="section__element">
      <p class="label">Skip launch</p>
      <input
        class="cb-toggle"
        type="checkbox"
        checked={skipLaunch}
        on:change={() => (skipLaunch = !skipLaunch)}
      />
    </div>
    <button
      on:click={onLaunch}
      disabled={!isConfigReady || skipLaunch}
      title="Lauch twinserver"
    >
      Launch
    </button>
  </div>
  {#if responseLaunchError}
    <p style="color:red">{responseLaunchError}</p>
  {/if}

  <div class="section">
    <h2>Message</h2>
    <div class="section__element">
      <p class="label">Command</p>
      <input
        type="text"
        value={command}
        on:input={(e) => {
          command = e.target["value"];
        }}
      />
    </div>
    <div class="section__element">
      <p class="label">Payload</p>
      <textarea
        type="text"
        value={payload}
        on:change={(e) => {
          payload = e.target["value"];
        }}
      />
    </div>
    <div>
      <button on:click={onSend} disabled={!isReady} title="Send Message">
        Send
      </button>
      {#if illustrationMsg}
        <p style="color:red">{illustrationMsg}</p>
      {/if}
    </div>
  </div>
  <div class="response">
    {#if responseError || responseData}
      <h2>Response</h2>
      {#if responseError}
        <p style="color:red">{responseError}</p>
      {:else if responseData}
        <pre id="json" style="color:green">{responseData}</pre>
      {/if}
    {/if}
  </div>
</div>

<style lang="scss">
  div.section {
    display: flex;
    flex-direction: column;
    &__element {
      display: flex;
      flex-direction: row;
      p {
        width: 120px;
      }
      select,
      input,
      textarea {
        margin-left: 1.5rem;
      }
    }
  }
  button {
    width: 120px;
    cursor: pointer;
  }

  /* Toggle Button */
  .cb-toggle {
    -webkit-appearance: none;
    -webkit-tap-highlight-color: transparent;
    position: relative;
    border: 0;
    outline: 0;
    cursor: pointer;
    margin: 10px;
  }

  /* To create surface of toggle button */
  .cb-toggle:after {
    content: "";
    width: 50px;
    height: 25px;
    display: inline-block;
    background: rgba(0, 0, 0);
    border-radius: 18px;
    clear: both;
  }

  /* Contents before checkbox to create toggle handle */
  .cb-toggle:before {
    content: "";
    width: 15px;
    height: 15px;
    display: block;
    position: absolute;
    top: 10px;
    left: 10px;
    border-radius: 50%;
    background: rgb(255, 255, 255);
    box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.6);
  }

  /* Shift the handle to left on check event */
  .cb-toggle:checked:before {
    left: 35px;
    box-shadow: -1px 1px 3px rgba(0, 0, 0, 0.6);
  }
  /* Background color when toggle button will be active */
  .cb-toggle:checked:after {
    background: teal;
  }
</style>
