import { MessageBusClient } from "ts-rmb-redis-client";

async function main() {
  let myTwinId = 0; // Add Your twin id
  if (myTwinId === 0) {
    console.log("Please add your twin id, and run again");
    return;
  }
  const importCmd = "twinserver.stellar.import";
  const walletName = "mywallet";
  let walletSecret = "ADD_YOUR_SECRET";
  if (walletSecret === "ADD_YOUR_SECRET") {
    console.log("Please add your wallet secret, and run again");
    return;
  }
  const importPayload = JSON.stringify({
    name: walletName,
    secret: walletSecret,
  });
  const rmb = new MessageBusClient();
  const importMsg = rmb.prepare(importCmd, [myTwinId], 0, 2);
  const importMessage = await rmb.send(importMsg, importPayload);
  const importResult = await rmb.read(importMessage);
  console.log(importResult);
  const balanceCmd = "twinserver.stellar.balance_by_name";
  const balancePayload = JSON.stringify({ name: walletName });
  const balanceMsg = rmb.prepare(balanceCmd, [myTwinId], 0, 2);
  const balanceMessage = await rmb.send(balanceMsg, balancePayload);
  const balanceResult = await rmb.read(balanceMessage);
  console.log(balanceResult);
  return;
}

main();
