# Exercises - Mininet-wifi

These exercises are based on the book: *Emulando Redes sem Fio com Mininet-Wifi*. 

Using the following link users can access the first 100 pages of the book: https://github.com/ramonfontes/mn-wifi-book-pt/blob/master/preview-book.pdf.

The steps to be followed in each one of the parts are contained in the sections of the book.



## First steps with Mininet-wifi

After following the steps of Section 2.1:

:::danger

After each execution of the command ping, What is the delay observed between sta1 and sta2? Was there any packet loss in the channel? Justify your answers objectively.

Use the command `iperf` to evaluate the throughput (Mbps) between sta1 and sta2.
:::

## Accessing nodes information

After following the steps of Section 2.3:

:::danger
Comment on each one of the informations specified by the sta1 parameters list.
:::


## Visualizing 2D and 3D graphics 

After following the steps of Section 2.5.3:

:::danger
Access the script mininet-wifi/examples/position.py and change the net.plotGraph function according to the steps in section 2.5.3. Plot the recommended 3 graphics.
:::


## Distance x Bandwidth/RSS Relationship 

After following the steps of Section 2.10:

:::danger
Use the file position.py to create a figure or table representing the measurements of throughput using iperf from a node distancing at ***x** meters*.

Feel free to use any propagation model. For each distance provide the sinal level (RSSI) and throughput (Mbps) observed in the measurements.
:::

:::warning
Mininet-wifi detains a CCA Threshold (Clear Channel Assessment) that closes communication when the signal level reaches -92dBm.  
Explain what the CCA Threshold means!
:::



## Traffic Analysis


After following the steps of Section 3.2:

:::danger
Compare the packet captures between an Ethernet link (802.3) and wireless (802.11), and explain the difference among the number of MAC addresses in each one of them, and their role in the function of context of the link layer in LANs.
:::


## Openflow Protocol

After following the steps of Sections 3.6.1, 3.6.2 and 3.6.3:

:::danger
Execute ping among hosts h1 and h2 (as mentioned in Section 3.6.1). Explain the reasons of the delay among the first ICMP packet and the following others. How such delay could be avoided?  

Following the steps in Section 3.6.5: explain how nodes mobility affects/impacts the topologies based on Openflow. Propose and discuss possible approaches to circumvent such impacts.
:::


## Congratulations!

Now you know a little about Mininet-wifi!