from brownie import DutchAuction, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract DutchAuction...")
    deploy_wallet = DutchAuction.deploy("0x2DFA0332E058c4FcC9d1b8C165eFf1CF52368d03", 12345678, {"from": account}, publish_source = True)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "a+") as dep:
        dep.write("\n\nDutchAuction => "+deploy_wallet.address)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()