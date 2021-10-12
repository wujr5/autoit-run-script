const { tcpPingPort } = require("tcp-ping-port")
const fs = require('fs');

const aDeviceList = fs.readFileSync('online-door.txt', { encoding: 'utf-8' }).split('\n').map(i => {
  let text = i.trim();
  return text.split(' ');
});

async function testTcp(ip) {
  return tcpPingPort(ip, 5005)
}

let aOnlineDevice = [];

async function startRun() {
  for (let i = 830; i < aDeviceList.length; i++) {
    // if (i > 10) break;
    let res = await testTcp(aDeviceList[i][0]);
    console.log(i + 1, '/', aDeviceList.length, res)

    if (res.online) aOnlineDevice.push(res.host + ' ' + aDeviceList[i][1]);
  }

  // fs.writeFileSync('online-door-2.txt', aOnlineDevice.join('\n'), { encoding: 'utf-8' })
}

startRun();
