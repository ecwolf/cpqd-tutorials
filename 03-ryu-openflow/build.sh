sudo apt install gcc python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev python3-dev python3-pip

sudo pip3 install 'webob>=1.2' 'msgpack>=0.3.0' 'netaddr' 'oslo.config>=2.5.0' 'ovs>=2.6.0' 'routes' 'tinyrpc==0.9.4' 'eventlet>=0.18.2'

git clone https://github.com/osrg/ryu

cd ryu 
sudo python3 setup.py install
cd -

sudo apt install mininet
