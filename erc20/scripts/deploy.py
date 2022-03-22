from brownie import FPS, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract EtherWallet...")
    deploy_wallet = FPS.deploy({"from": account}, publish_source = True)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "r+") as dep:
        dep.write("FPS => https://rinkeby.etherscan.io/address/"+deploy_wallet.address+"\n\n")


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()