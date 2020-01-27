sudo apt install net-tools

git clone https://github.com/containernet/vim-emu

wget https://osm-download.etsi.org/ftp/osm-7.0-seven/install_osm.sh
chmod +x install_osm.sh
./install_osm.sh --vimemu 2>&1 | tee osm_install_log.txt

