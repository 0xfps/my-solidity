from brownie import IterableMapping, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract EtherWallet...")
    deploy_wallet = IterableMapping.deploy({"from": account}, publish_source = True)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "r+") as dep:
        dep.write("\n\nIterable Mapping => https://rinkeby.etherscan.io/address/"+deploy_wallet.address)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()