from brownie import FPS, network, accounts, reverts

def getAccount():
    acc = accounts[0]
    return acc

def deploy():
    acc = getAccount()
    dep = FPS.deploy({"from":acc})
    return dep
   
def getMain(value, number):
    val = value / (10 ** number)
    return val


# Tests deployments and constructor settings.

def testDeploy():
    acc = getAccount()
    deps = deploy()
    
    decimals = deps.decimals()
    name = deps.name()
    symbol = deps.symbol()
    total_supply = deps.totalSupply()
    
    
    # Test for constructor settings.
    
    test_address = "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"
    
    
    # Returns the address balance.
    
    test_address_balance = deps.balanceOf(test_address)
    
    main_test_balance = getMain(test_address_balance, decimals)
    
    
    # Test for fake balance.
    
    fake_bal = ""
    comp_fake_bal = ""
    
    with reverts():
        fake_bal = deps.balanceOf(accounts[2])
    
    
    assert decimals == 18
    assert name == "FPS"
    assert symbol == "$FPS"
    assert total_supply == 1000000000 * (10 ** 18)
    assert main_test_balance == 1 * (10 ** 9)
    assert comp_fake_bal == fake_bal
    


def testTransfer():
    acc = getAccount()
    deps = deploy()
    
    # Address to transfer to.
    
    amount = 100 * (10 ** 18)
    to = accounts[3]
    
    fake_bal = ""
    
    with reverts():
        fake_transfer = deps.transfer(to, amount, {"from": acc})
    
    transfer = deps.transfer(to, amount, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    
    bal = deps.balanceOf(to)
    main_bal = getMain(bal, 18)
    
    owner_bal = deps.balanceOf("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593")
    main_owner_bal = getMain(owner_bal, 18)
    
    assert fake_bal == ""
    assert main_bal == 100
    assert main_owner_bal < 1 * (10 ** 9)
    assert main_owner_bal == (1 * (10 ** 9) - 100)



def testApproveAllowanceAndTransferFrom():
    acc = getAccount()
    deps = deploy()
    
    
    # Fake approved account.
    
    fake_acc = accounts[3]
    
    approved_address = accounts[6]
    approved_amount = 500 * (10 ** 18)
    
    deps.transfer(approved_address, 100 * (10 ** 18), {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    
    fake_approve = False
    
    with reverts():
        fake_approve = deps.approve(approved_address, approved_amount, {"from": acc})
        
    approve = deps.approve(approved_address, approved_amount, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})


    
    fake_allowance = 0
    
    with reverts():
        fake_allowance = deps.allowance(acc, fake_acc)
        fake_allowance = deps.allowance(acc, approved_address)
    
   
    allowance = deps.allowance("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", approved_address, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    main_allowance = getMain(allowance, 18)
    
    
    
    fake_transfer_from = 0
    
    with reverts():
        fake_transfer_from = deps.transferFrom("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", accounts[8], 100 * ( 10 ** 18), {"from": accounts[7]})
        
    
    transferFrom = deps.transferFrom("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", accounts[5], 100 * ( 10 ** 18), {"from": approved_address})
    
    balance_of_5 = deps.balanceOf(accounts[5])
    main_balance_of_5 = getMain(balance_of_5, 18)
    
    
    allowance_of_approved = deps.allowance("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", approved_address, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    main_allowance_of_approved = getMain(allowance_of_approved, 18)
    
    _bal = deps.balanceOf("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593")
    main__bal = getMain(_bal, 18)
    
    
    assert fake_approve == False
    assert fake_allowance == 0
    assert main_allowance == 500
    assert fake_transfer_from == 0
    assert main_balance_of_5 == 100
    assert main_allowance_of_approved == 400
    assert main__bal == (1 * (10 ** 9) - 200)
    


def testMintAndBurn():
    acc = getAccount()
    deps = deploy()
    
    mint_val = 1000
    burn_val = 200
    
    fake_mint = False
    
    with reverts():
        deps.mint(mint_val, {"from": accounts[9]})
        fake_mint = True
    
    deps.mint(mint_val, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    deps.burn(burn_val, {"from": "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"})
    
    tot = deps.totalSupply()
    main_tot = getMain(tot, 18)
    
    bal = deps.balanceOf("0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593")
    main_bal = getMain(bal, 18)
    
    assert main_tot == ((1 * (10 ** 9)) + 1000 - 200)