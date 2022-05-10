from brownie import MyAuction, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract MyAuction...")
    deploy_wallet = MyAuction.deploy("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", 12345678, {"from": account}, publish_source = True)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "r+") as dep:
        dep.write("\n\nMyAuction => https://rinkeby.etherscan.io/address/"+deploy_wallet.address)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()