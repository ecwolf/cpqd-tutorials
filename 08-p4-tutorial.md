# Exercises - P4

The objective of these exercises is to introduce the concept of programmable data planes using the P4 language *Programming Protocol-independent Packet Processors* https://p4.org.

This exercise is divided in three parts:

1. Analysis of a P4 code
2. Execution of a P4 program
3. Programming with P4

These exercises were adapted from https://github.com/p4lang/tutorials.

## Part 1: Analysis of a P4 code

In this activity we are going to analyze the structure of a P4_16 code and the main parts of it.

First, enter into the directory:

```bash
$ cd /home/p4/tutorials/exercises/basic
```

And open the P4 code **basic.p4**:

```bash
$ subl basic.p4
```

In this code, identify the parts of the code where the following operations are defined:

- Headers definition of Ethernet and IPv4
- Parser of the Headers
- Destination IPv4 address lookup (LPM)
- Source and destination MAC address update
- Update of the TTL value
- Egress port definition
- Checksum calculation

After identified the parts of the code, we are going to execute our first P4 program with mininet.

When we write a P4 code, the first step is to compile the code, to verify if there is no error, and then we run with mininet.

To facilitate the process, use the command `make` to compile and run.



## Part 3: Programming with P4

One of the important characteristics of P4 is the possibility of define new protocols (e.g., headers definition) or modify how their work.

In this activity we are going to define a new protocol called **planet**. This protocol will be encapsulated in an Ethernet frame using the Ethernet type *0x66AA*.

The **planet** protocol have 3 fields: **source** (size of 24 bits), **destination** (size of 24 bits), and **seq** (size of 32 bits).

:::warning
Use the same fields name in the P4 code.
:::

The P4 code includes the forwarding functions using the RA value. This value is loaded to the tables by the controller.

:::warning
P4 is used to define the data structures of the tables. The control plane is in charge of fill all the necessary information into the tables.
:::

To add the new protocol, we need to enter into the directory:

```bash
$ cd /home/p4/Class/BB-Gen
```

The P4 code can be opened with Sublime Text for an easy edition with the command:

```bash
$ subl examples/p4_src/planets.p4
```
:::warning
In P4 code available it is necessary to add just the new protocol definition.
:::

In the P4 code, we need to add the new header definition below of:

```bash
//----------TODO----------//
```
This example is based on P4 version 14. It is necessary this version to the correct generation of test files (PCAP traces).

In P4_14 there are some syntax changes compared to P4_16. For instance when a header is defined in P4_14, the code used has this format:

```c
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
```
Using the giving information and the P4_14 structure, add the corresponding code to define the new protocol **planet**.

:::warning
The header name during the definition should need a **_t** at the end (**planet_t**).

In the folder `example/p4_src/` there are some P4_14 code that can be used as example.
:::

:::danger
Considering the size of the fields, and considering the **seq** field as a student identifier (RG of the student), calculate how many students and planets can be supported.
:::

:::danger
With the new protocol, image how the headers fields can be used to create a new communication process between different hosts.
:::

With the P4 code completed, including the new protocol, lets compile and generate all the files for the test.

In the directory `/home/p4/Class/BB-Gen/` execute the script:

```bash
$ ./install.sh <RG Number>
```

For example:

```bash
$ ./install.sh 111111111
```
This script will perform the following actions:

- Compile the P4 (if there is an error in the code it will appear in the terminal).
- Generate the dissector to visualize the new protocol in Wireshark. Without a dissector it is not possible to visualize custom protocols.
- Generate the PCAP files with the new protocol to be used in the next tests.
- Translate from P4_14 to P4_16 for the final tests.
- Prepare the Mininet files for the test. Will be added the student RG into the tables during the Mininet execution.

If we do not have any error, we need to go to the directory:

```bash
$ cd /home/p4/tutorials/exercises/planet/
```

And execute the Mininet topology using:

```bash
$ make
```

```
                            1 +----+ 2                       
          h1 -------------- +-||s1||-+ -------------- h2                    
      10.0.10.1               +----+              10.0.20.2                       
```

In Mininet, open external terminal of h1 and h2.

```bash
mininet> xterm h1 h2
```

And execute wireshark in both terminals.

```bash
$ wireshark \&
```

:::warning
If a message of *Lua: Error during loading* appears, press *OK*
:::

In the xterm terminal of **h1** run the command:

```bash
$ ./send.sh
```

:::danger
Check in the Wireshark terminal of **h1** if the packets where sent.

Check in the Wireshark terminal of **h2** if the packets where received.
:::

:::warning
In Wireshark we can observe the new defined protocol **P4_PLANET Protocol**. Check the **seq** values of the packets in h1 and h2.

The value presented in wireshark is in HEX format, to verify in decimal format we can use a converted tool like https://www.rapidtables.com/convert/number/hex-to-decimal.html.
:::

In the xterm terminal of **h2** run the command:

```bash
$ ./send.sh
```

:::danger
Check in the Wireshark terminal of **h1** if the packets where sent.

Check in the Wireshark terminal of **h2** if the packets where received.
:::

If we see the beginning of the mininet execution (after the `make` command),
we will have an output similar to:

planet_fib_match: planet.seq=111111111 =>fib_hit_nexthop(dmac=08:00:00:00:01:11,port=1)
planet_fib_match: planet.seq=222222 =>fib_hit_nexthop(dmac=08:00:00:00:02:00,port=2)

They represent the the messages from the controller to fill the switch tables.

:::danger
Identify the relationship between this information and the tables in
the P4 code.
:::

:::warning
The physical interfaces of the switch are represented by *ports*
(port 1, port 2).
Check the figure of the topology for the corresponding port number of
each interface.
:::

:::danger
With all the collected information, explain, why the packets are
received only in one direction?.
:::

## Part 4: Advance Programming with P4 (Optional)

The objective of this activity is to implement a basic calculator
using a custom protocol header written in P4. The header will contain
an operation to perform and two operands. When a switch receives a
calculator packet header, it will execute the operation on the
operands, and return the result to the sender.

To perform the activity go the folder:

```bash
$ cd /home/p4/
```

Create and enter into a new folder called **calc**:

```bash
$ mkdir calc
```

```bash
$ cd calc
```

Download the repository:

```bash
$ git clone https://github.com/p4lang/tutorials.git
```

The activity is in the folder:

```bash
$ cd tutorials/exercises/calc
```

The directory also contains a skeleton P4 program,
`calc.p4`, which initially drops all packets.  Your job will be to
extend it to properly implement the calculator logic.

As a first step, compile the incomplete `calc.p4` and bring up a
switch in Mininet to test its behavior.

:::warning
To compile and run the code we use the command `make`
:::

This will:
   * compile `calc.p4`, and

   * start a Mininet instance with one switches (`s1`) connected to
     two hosts (`h1`, `h2`).
   * The hosts are assigned IPs of `10.0.1.1` and `10.0.1.2`.

There is a small Python-based driver program that will allow
you to test your calculator. You can run the driver program directly
from the Mininet command prompt:

```
mininet> h1 python calc.py
```

The driver program will provide a new prompt, at which you can type
basic expressions. The test harness will parse your expression, and
prepare a packet with the corresponding operator and operands. It will
then send a packet to the switch for evaluation. When the switch
returns the result of the computation, the test program will print the
result. However, because the calculator program is not implemented,
you should see an error message.

```
> 1+1
Didn't receive response
>
```

To implement the calculator, you will need to define a custom
calculator header, and implement the switch logic to parse header,
perform the requested operation, write the result in the header, and
return the packet to the sender.

We will use the following header format:

```
0                1                  2              3
+----------------+----------------+----------------+---------------+
|      P         |       4        |     Version    |     Op        |
+----------------+----------------+----------------+---------------+
|                              Operand A                           |
+----------------+----------------+----------------+---------------+
|                              Operand B                           |
+----------------+----------------+----------------+---------------+
|                              Result                              |
+----------------+----------------+----------------+---------------+
```
-  P is an ASCII Letter 'P' (0x50)
-  4 is an ASCII Letter '4' (0x34)
-  Version is currently 0.1 (0x01)
-  Op is an operation to Perform:
-   '+' (0x2b) Result = OperandA + OperandB
-   '-' (0x2d) Result = OperandA - OperandB
-   '&' (0x26) Result = OperandA & OperandB
-   '|' (0x7c) Result = OperandA | OperandB
-   '^' (0x5e) Result = OperandA ^ OperandB

We will assume that the calculator header is carried over Ethernet,
and we will use the Ethernet type 0x1234 to indicate the presence of
the header.

Given what you have learned so far, your task is to implement the P4
calculator program. There is no control plane logic, so you need only
worry about the data plane implementation.

A working calculator implementation will parse the custom headers,
execute the mathematical operation, write the result in the result
field, and return the packet to the sender.

Compile and run the code with `make`. This time, you should see the
correct result:

```
> 1+1
2
>
```

___

## Congratulations!

Now you know a little about P4!
