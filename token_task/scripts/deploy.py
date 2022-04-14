from brownie import Cix, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract Cix...")
    deploy_wallet = Cix.deploy({"from": account}, publish_source = False)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "a+") as dep:
        dep.write("Cix => https://rinkeby.etherscan.io/address/"+deploy_wallet.address+"\n\n")


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()