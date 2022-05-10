from brownie import FPS, config, network, accounts

def deploy():
    print("Getting account....")
    account = get_account()
    print(f"Deployer account {account} confirmed!!!")
    print("Deploying contract FPS...")
    deploy_wallet = FPS.deploy({"from": account}, publish_source = True)
    print(f"Contract deployed successfully at {deploy_wallet.address}")

    with open("../Deployment Addresses.txt", "a+") as dep:
        dep.write("\n\nFPS => https://rinkeby.etherscan.io/address/"+deploy_wallet.address)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config['wallet']['from_key'])


def main():
    deploy()