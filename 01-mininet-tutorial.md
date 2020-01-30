# Exercises - Mininet

These exercises will make you feel comfortable with Mininet.
The part 3 of these exercises were extracted from https://hackmd.io/@pmanzoni/SyWm3n0HH?type=view. 

This exercise is divided in three parts:

1. Understanding Mininet Concepts
2. Running Mininet Topologies
3. Playing with Mininet shell 


## Part 1: Understanding Mininet Concepts


In a terminal of the Mininet, type: 

```bash 
$ sudo mn --mac
```

This command will start Mininet and will configure a small network with two hosts and a switch. Also use the option `--topo` in the mn command to discover more topologies available.


At the Mininet terminal (mininet>), execute the `net` command to observe the network created. Then run `intfs` to check all network interfaces, and check for connectivity between hosts. Type `xterm h1` or `exterm h2` into the Mininet CLI to open the terminal (console) of both hosts h1 and h2. You can now execute commands as if you are inside the Linux machine of these hosts.


Follow the steps below:

1) Access Wireshark typing wireshark in h2 xterminal. Use-o para monito-rar a interface deste host.
2) Try to ping between h1 e h2, using h1 xterminal: `ping -c1 10.0.0.2`
3) For each host (h1 e h2) and switch (s1):
    3.1) Check the interfaces IP address.  
    3.2) Check the interfaces MAC address.  
    3.3) Check the routing table.  
    3.4) Check the ARP table.  

Tip: try to use the Linux toolset: ifconfig, route, arp, netstat, ip route, etc. At any time you can finish the mininet session terminal by typing `quit`, `exit` or `Ctrl+D`.


------

## Part2: Running Mininet Topologies

First let's download the topology scripts:

```bash
$ git clone https://github.com/intrig-unicamp/ea080.git

$ cd ea080/lab1
```


Run the python script, typing:

```bash
$ sudo python pratica-1-II.py
```

The script source code is shown below.

```python
import atexit
from mininet.net import Mininet
from mininet.topo import Topo
from mininet.cli import CLI
from mininet.log import info,setLogLevel
net = None

def createTopo():
	topo=Topo()
	#Create Nodes
	topo.addHost("h1")
	topo.addHost("h2")
	topo.addHost("h3")
	topo.addHost("h4")
	topo.addSwitch('s1')
	topo.addSwitch('s2')
	topo.addSwitch('s3')
	#Create links
	topo.addLink('s1','s2')
	topo.addLink('s1','s3')
	topo.addLink('h1','s2')
	topo.addLink('h2','s2')
	topo.addLink('h3','s3')
	topo.addLink('h4','h3')
	return topo

def startNetwork():
	topo = createTopo()
	global net
	net = Mininet(topo=topo, autoSetMacs=True)
	net.start()
	CLI(net)

def stopNetwork():
	if net is not None:
		net.stop()

if __name__ == '__main__':
	atexit.register(stopNetwork)
	setLogLevel('info')
    startNetwork()
```

Execute the command pingall in the mininet console, and check if pings fail (i.e., hosts not replying are represented by an X mark).

:::info
Modify the script so you can run it again and all hosts will be connected by the pingall command.
:::


Now, run the script pythonpratica-1-III.py (also located inside lab1 folder). 
The script source code is shown below. Look how the link parameters were specified (bandwidth Mbps, latency ms, and frame loss ratio %).

```python
import atexit
from mininet.net import Mininet
from mininet.topo import Topo
from mininet.cli import CLI
from mininet.log import info,setLogLevel
from mininet.link import TCLink
net = None

def createTopo():
	topo=Topo()
	#Create Nodes
	topo.addHost("h1")
	topo.addHost("h2")
	topo.addHost("h3")
	topo.addHost("h4")
	topo.addSwitch('s1')
	topo.addSwitch('s2')
	topo.addSwitch('s3')
	#Create links
	topo.addLink('s1','s2',bw=100,delay='100ms',loss=10)
	topo.addLink('s1','s3')
	topo.addLink('h1','s2')
	topo.addLink('h2','s2')
	topo.addLink('h3','s3')
	topo.addLink('h4','s3')
	return topo

def startNetwork():
	topo = createTopo()
	global net
	net = Mininet(topo=topo, autoSetMacs=True, link=TCLink)
	net.start()
	CLI(net)

def stopNetwork():
	if net is not None:
		net.stop()

if __name__ == '__main__':
	atexit.register(stopNetwork)
	setLogLevel('info')
	startNetwork()
```

:::info
Using the ping command, check the rtt and loss between h1 and h2 and h1 and h4. 
To check the network throughput use the command iperf, e.g., `iperf h1 h2` or `iperf h1 h4`
:::


Editing the previous topology script, try to create a (data center like) network topology as in the image below, using the following parameters:

```
                                +----+
                         +------||c1||----+
                         |      +----+    |
                         |                |
                       +----+          +----+
                     +-||d1||-+      +-||d2||-+
                     | +----+ |      | +----+ |
                     |        |      |        |
                     |        |      |        |
                   +----+  +----+  +----+  +----+
                   ||a1||  ||a2||  ||a3||  ||a4||
                   +----+  +----+  +----+  +----+
                    |  |    |  |    |  |    |  |
                   h1  h2  h3  h4  h5  h6  h7  h8

```

* Switches Core (c1) to distribution switches (d1 and d2): 10 Gbps, 1 ms.
* Distribution switches (d1 and d2) to access switches (a1, a2, a3, a4): 1 Gbps, 3 ms.
* Access switches to hosts (h1-8): 100 Mbps, 5 ms.

:::info
Modify the topology file to insert 15% loss in the link between host h8  switch a4. How to measure the packet loss to h8 using ping? What's the average loss you see in practice?
Using `iperf`, measure the throughput between: h1 and h2, h1 and h3, and h1 and h5.
:::

Change the link parameters as following:
* Switches Core (c1) to distribution switches (d1 and d2): 1 Gbps, 2 ms.
* Distribution switches (d1 and d2) to access switches (a1, a2, a3, a4): 100 Mbps, 2 ms.
* Access switches to hosts (h1-8): 10 Mbps, 2 ms.

:::info
Using `iperf`, measure the throughput between: h1 and h2, h1 and h3, and h1 and h5.
Explain the differences from the previous exercise.
:::
___

## Part3: Playing with Mininet shell 


Create the following network:

    $ sudo mn --topo=single,3 --controller=none --mac
    


* `--controller=none`  means that commands will be provided manually
* `--mac`  means that MACs will be simplified

Now execute the `dump` and the `net` commands just to check the topology.

The command to see how switch `s1` ports map to OpenFlow Port (OFP) numbers is:

    mininet> sh ovs-ofctl show s1 

:::warning
**`sh`** allows to execute shell commands inside mininet. You could execute them from a separate xterm using sudo, i.e., `$ sudo ovs-ofctl show s1`
:::


Let's create the first flow entry:

    mininet> sh ovs-ofctl add-flow s1 action=normal

**`normal`** means traditional switch behaviour, that is the classical switch forwarding operations. Let's test with `pingall`.

:::danger
What's the result? Everything was connected?
:::

Now execute:

    mininet> sh ovs-ofctl dump-flows s1

:::danger
What means the info output from the command above?
:::

Delete the entry (the flow) using:

    mininet> sh ovs-ofctl del-flows s1
    
this command deletes all flows in s1. Now execute once again:

    mininet> sh ovs-ofctl dump-flows s1

You'll see that there are no moree flows defined.

Now execute once again:

    mininet> pingall

:::danger
What happens? Why?
:::


### Using layer 1 data

In this part you will work at the physical ports level. We want to programme the switch so that everything that comes at the switch s1 from OpenFlow Port 1 is sent out to OpenFlow Port 2, and vice-versa.

The required commands are:

    mininet> sh ovs-ofctl add-flow s1 priority=500,in_port=1,actions=output:2
    mininet> sh ovs-ofctl add-flow s1 priority=500,in_port=2,actions=output:1
    
The two instructions basically indicate the switch that what enters from port 1 has to be forwarded to port2... and vice-versa.

:::danger
Now run,
`mininet> h1 ping -c2 h2 `
and,
`mininet> h3 ping -c2 h2`
What happens? Why?
:::

Now execute once again:

    mininet> sh ovs-ofctl dump-flows s1

Now you can see the two newly created flows and the infos about them. The priority value is important. If a packet enters a switch and there are various rules, only the one with higher value is executed.

Let's add another flow:

    mininet> sh ovs-ofctl add-flow s1 priority=32768,action=drop

This flow has an higher priority (32768 which corresponds to the defaults value; Priorities range between 0 and 65535.)

:::danger
What's the effect of adding this flow? Try it with ping!
:::

Let's now eliminate such the command below (it deletes the flow with all the default parameters
):

    mininet> sh ovs-ofctl del-flows s1 --strict
    

Try again ping.

==Now delete all the flows in the switch==


### Using layer 2 data

In this section you will repeat the same operations but instead of using the port numbers, using the MAC addresses of the hosts. Since we execute mininet with the **`--mac option`**, the hosts will have simplified MAC addresses:

Execute the command below:

    mininet> sh ovs-ofctl add-flow s1 dl_src=00:00:00:00:00:01,dl_dst=00:00:00:00:00:02,actions=output:2
    mininet> sh ovs-ofctl add-flow s1 dl_src=00:00:00:00:00:02,dl_dst=00:00:00:00:00:01,actions=output:1

Try `pingall` to see if it works. As you will see it doesn't work since ping works at IP level and the first thing it does is to use ARP to find out the MAC addresses of the different hosts. Our switch, with the rules it currently has, it's filtering out ARP data traffic.
ARP is a broadcast protocol so we need to add another rule:

    mininet> sh ovs-ofctl add-flow s1 dl_type=0x806,nw_proto=1,action=flood

This rule adds a flow that "floods" all Ethernet frames of type 0x806 (ARP) to all the ports of the switch. `nw_proto=1` indicate an "ARP request". Since the replies in ARP are unicast,  we already have the right flows set.

we now obtain:

    mininet-wifi> pingall
    *** Ping: testing ping reachability
    h1 -> h2 X 
    h2 -> h1 X 
    h3 -> X X 
    *** Results: 66% dropped (2/6 received)

which basically means that now h1 and h2 are in contact but h3 still is disconnected.

==Now delete all the flows in the switch==


### Using layer 3 data

We'll now use layer 3 (IP) infos for the creation of flows.

All hosts will talk one to another, and also we will give priority to data coming from h3 using DSCP, that is using DiffServ. In Openflow there are many various rules to modify packet contents, this is a basic example.

:::warning
Differentiated services or DiffServ is a computer networking architecture that specifies a simple and scalable mechanism for classifying and managing network traffic and providing quality of service (QoS) on modern IP networks. DiffServ can, for example, be used to provide low-latency to critical network traffic such as voice or streaming media while providing simple best-effort service to non-critical services such as web traffic or file transfers.
:::

So we first start by excuting:

    mininet> sh ovs-ofctl add-flow s1 priority=500,dl_type=0x800,nw_src=10.0.0.0/24,nw_dst=10.0.0.0/24,actions=normal
    mininet> sh ovs-ofctl add-flow s1 priority=800,dl_type=0x800,nw_src=10.0.0.3,nw_dst=10.0.0.0/24,actions=mod_nw_tos:184,normal
    

:::danger
Describe what the config lines above mean!
:::

:::warning
We use the 184 since, to specify the 46 DSCP value in the IP TOS field, we have to shift it 2 bits on the left according to the meaning of the bits of TOS field.
:::

Now we have to again enable ARP. We'll do it in a slightly different way:

    mininet> sh ovs-ofctl add-flow s1 arp,nw_dst=10.0.0.1,actions=output:1
    mininet> sh ovs-ofctl add-flow s1 arp,nw_dst=10.0.0.2,actions=output:2
    mininet> sh ovs-ofctl add-flow s1 arp,nw_dst=10.0.0.3,actions=output:3

In this case we are not using flooding, which can be a useful behaviour (imagine a 24 ports switch)

:::danger
Try if it works with `pingall`. Check with wireshark if packets have DSCP modified from and to h3.
:::

==Now delete all the flows in the switch==


### Using layer 4 data

To conclude we'll see how the same can be done at layer 4, the application layer. In this example a simple python web server (the one you used in the previous session) will be executed in host 3, and host 1 and host 2 will connect to that server that runs at port 80.

So let's start the web server on h3:

    mininet> h3 python -m SimpleHTTPServer 80 &
    
Let's enable ARP (in a simpler way):

    mininet> sh ovs-ofctl add-flow s1 arp,actions=normal

Let's introduce a rule that forwards all TCP traffic (`nw_proto=6`) with destination port 80, to the switch port 3:

    mininet> sh ovs-ofctl add-flow s1 priority=500,dl_type=0x800,nw_proto=6,tp_dst=80,actions=output:3
    
:::warning
This rule could be used to redirect all the data traffic to a firewall that is connected to a specific port.
:::
    
And, finally, we have to add this rule:

    mininet> sh ovs-ofctl add-flow s1 priority=800,ip,nw_src=10.0.0.3,actions=normal
    
:::danger
What does this last rule mean?
:::

    
To check whether eveything works, try:

    mininet> h1 curl h3
    

___

## Congratulations!

Now you know a little about Mininet!