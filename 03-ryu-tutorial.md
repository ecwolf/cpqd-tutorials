# Exercises - Ryu and OpenFlow


These exercises are divided in three parts:

1. OpenFlow Intro
2. Learning Switch
3. REST API


## Part 1: OpenFlow Intro


Start a first topology:

```bash
$ sudo mn --mac --switch ovsk --controller remote
```

In another terminal, start Wireshark to monitor control packets  from switch s1. Select the lo interface and filter on openflow_v4 packets to look the OpenFlow messages among the switch and the controller (to be started).

```bash
$ sudo wireshark -i lo -k &
```

The Ryu controller detains a management framework responsible for the support of control plane with data plane equipments. So, let's start the main ryu framework without any Application. In another terminal enter:

```bash
$ ryu-manager
``` 

Observe the packets shown in Wireshark.

:::danger
What messages the OpenFlow protocol presents and what is their function?
:::

Go back to the mininet terminal and have a ping between h1 and h2

```bash
mininet> h1 ping h2 -c5
```

In wireshark, observe the packets again.

:::danger
What the ping concluded with success?

Was there any message exchanged between the switch and the controller?

If a controller application was implemented, what would be the common expected behaviour (considering the Openflow protocol) in this situation?
:::


## Part 2: Learning Switch

Let's implement our first Openflow App, a learning switch. Let's discuss how a switch normally works and introduct such behavior in the Openflow App.

1. A learning switch forwards packets based on the knowledge extracted from MAC addresses. When receiving a packet, if the switch does not have any rule that matches the packet header to forward it, it floods the packet in all the interfaces, otherwise it forwards the packet to the right MAC destination rule in the correct output interface.
2. In the Openflow App, in case the switch does not know the forwarding rule for a packet it will trigger a Packet-In message to the controller, that will handler the learning of MAC addresses associated with the switch interfaces and program them accordingly. In this way, similarly to a common learning switch the controller will trigger the flooding of packets in all interfaces, receive another Packet-In with the replied ARP and program the rule learned (i.e., a packet with the replied MAC address will be forwarded to that incoming interface).


### Ryu Controller
Let's look into some Ryu elements in order to conclude the exercise. For more information take a look at  https://github.com/osrg/ryu http://ryu.readthedocs.io/en/latest/

1. ofp_event: this class abstracts the allowed events the data plane can trigger to the control plane. The Ryu controller can be oriented on these events, and take actions when they take place. In the example below such artifact is used through a python decorator, executing a function when the event PacketIn takes place. 

```python
@set_ev_cls(ofp_event.EventOFPPacketIn)
    def handle_packet_in():
        learn_packet_in_fields()
        install_flows()
```


2. ofproto_parser: is the instantiated object that is responsible for the creation and serialization of Openflow messages. With this object instantiated we can interpret and send messages encoded in API that Ryu enables for the Openflow protocol. Each version of the Openflow protocol has a particular parser. The command below exemplifies how to get the parser instance from a switch abstracted instance named datapath.

```python
parser = datapath.ofproto_parser
```

3. datapath: is the object instance that abstracts a switch interconnected with the controller. It detains an ofproto_parser as its class member, "knowing" with Openflow version is used in the communication among the controller and switch. A datapath instance can be obtained from packet messages received by the controller events, as shown below.

```python
@set_ev_cls(ofp_event.EventOFPPacketIn)
    def handle_packet_in(self, ev):
       # ev : received event
       # msg: event message (i.e., as the decorator shows, a Packet In)
       msg = ev.msg
       datapath = msg.datapath
       out = creates_packet_out()
       datapath.send_msg(out)
       return 1
```

4. ofproto: contains the specific definitions of the Openflow protocol.


### Openflow 1.3

If not yet ended, finish the previous mininet console, and start a new on using:

```bash
$ sudo mn –-mac –-switch ovsk –-controller remote –-arp
```

Start Wireshark to monitor the packets among switch s1 and the controller (i.e., capture packets on the interface lo and apply the filter openflow_v4).

```bash
$ sudo wireshark -i lo -k &
```

In another terminal check the flows installed in the switch s1.

```bash
$ sudo ovs-ofctl dump-flows s1
```

In another terminal execute the app simple_switch_13 with the Ryu controller.

```bash
$ ryu-manager ryu.app.simple_switch_13
```

Observe again the flow rules installed in the switch s1.

```bash
$ sudo ovs-ofctl dump-flows s1
```

:::danger
What is the function of the observed flow entry?

Hint: Open the file /ryu/ryu/app/simple_switch_13.py and check the function that handles the event EventOFPSwitchFeatures.
:::

In the simple_switch_13.py file openned look for the function `add_flow()`.

:::danger
What are the arguments (input fields) of that function? 

What is the flow installed by such function?
:::

In the mininet console, run a ping among h1 and h2 (e.g., `ping h1 -c5 h2`). Observe how the first packet rtt is bigger than the others.


:::danger

Look for the Openflow messages in Wireshark, what are the new Openflow packets seen when compared to the previous exercises in Part 1?

How those packets were created? What is the purpose of those packets?
:::


## Part 3: REST API

In this part we will exercise how Ryu can enable a REST API to interface the control plane of switches. Take a look at the app in https://ryu.readthedocs.io/en/latest/app/ofctl\_rest.html. 
The REST API can be utilized by external applications to manage the controller and its interfaced data plane components.

In the previous part the hosts h1 and h2 were interconnected by a *reactive* application, in this part we work with a *proactive* methods, as if an application already "knew" h1 and h2 need connectivity.


If not yet ended, finish the previous mininet console, and start a new on using:

```bash
$ sudo mn –-mac –-switch ovsk –-controller remote –-arp
```

Start Wireshark to monitor the packets among switch s1 and the controller (i.e., capture packets on the interface lo and apply the filter openflow_v4).

```bash
$ sudo wireshark -i lo -k &
```

Now, in another terminal run the application enabling the REST API in Ryu.

```bash
$ ryu-manager ryu.app.ofctl_rest ryu.app.simple_switch_restd
```

The JSON message below can be used to request a flow entry to be deployed in a datapath via the ryu controller REST API. 

:::danger
Copy this message and modify it to create two messages, flow entries, that will be utilized to interconnect h1 and h2. 

Hint: Use some mininet commands to get the needed topology information (e.g., py h1.params, links, intfs, etc).

Fill the fields:
* dpid: the switch ID (e.g., 1)
* in_port: interface id of the incoming packets (e.g., 78).
* eth_dst: the destination MAC address of the packets (e.g., "00:00:33:00:44:55"). 
* eth_src: the destination MAC address of the packets. 
* port:  interface id to forward the outcoming packets.
:::


```json
{
    "dpid": A,
    "cookie": 1,
    "hard_timeout": 0,
    "priority": 123,
    "match":{
        "in_port": a,
        "eth_dst": "b",
        "eth_src": "c"
        },
    "actions":[
        {
        "type":"OUTPUT",
        "port": d
        }
    ]
} 
```

Open a terminal and run a POST request to the controller, using the flows created previously.

```bash
$ curl -X POST -d '{
    "dpid": 1,
    "cookie": 1,
    "cookie_mask": 1,
    "table_id": 0,
    "idle_timeout": 30,
    "hard_timeout": 30,
    "priority": 11111,
    "flags": 1,
    "match":{
        "in_port":22,
        "eth_src": "aa:bb:cc:dd:ee:ff",
        "eth_src": "11:22:33:44:55:66"
    },
    "actions":[
        {
            "type":"OUTPUT",
            "port": 2
        }
    ]
 }' http://localhost:8080/stats/flowentry/add
```

Check if the flow entries were actually created.

```bash
$ sudo ovs-ofctl dump-flows s1
```

Ping h1 to h2 and check if packets appear in Wireshark. 

```bash
mininet> h1 ping h2 -c5
```

:::danger
Comment the differences in the results with the previous Part. 

What are the benefits brought by the northbound REST API to networking applications?
:::


## Congratulations!

Now you know a little about Ryu and Openflow!