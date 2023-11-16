if [ ! -d "consensus/prysm" ]; then
    git clone https://github.com/flashbots/prysm.git consensus/prysm
    docker build -t eth-pos-devnet_beacon-chain:latest -f consensus/Dockerfile consensus/prysm
fi

if [ ! -d "execution/builder" ]; then
    git clone https://github.com/flashbots/builder.git execution/builder
    # 进到execution/builder中,然后执行
    git checkout local-relay-fix
    docker build -t eth-pos-devnet_geth:latest execution/builder
fi

running="$(docker-compose ps --services --filter "status=running")"
if [ -n "$running" ]; then
    docker-compose down
    rm -rf execution/geth
    rm -rf consensus/beacondata
    rm -rf consensus/validatordata
    rm consensus/genesis.ssz
    sleep 5
fi

docker-compose up -d