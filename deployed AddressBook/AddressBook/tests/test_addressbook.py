from brownie import AddressBook, config, network, accounts, reverts

def testDeploy():
   ## Arrange.
   print("Starting test...")
   account = accounts[0]

   ## Actions.
   deploy_var = AddressBook.deploy({"from": account})
   _zero_address = "0x0000000000000000000000000000000000000000"

   ## Assert.
   assert deploy_var.address != _zero_address
   

def testAdd():
   ## Arrange.
   print("Starting test...")
   account = accounts[0]

   ## Actions.
   deploy_var = AddressBook.deploy({"from": account})
   deploy_var.add("fps", "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", {"from": account})

   _zero_address = "0x0000000000000000000000000000000000000000"

   act_address = _zero_address

   with reverts():
      act_address = deploy_var.getAddress("Act")

   expected_fps_address = "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"
   actual_fps_address = deploy_var.getAddress("fps")

   ## Assert.
   assert act_address == _zero_address
   assert expected_fps_address == actual_fps_address



def testRename():
   account = accounts[0]
   
   deploy_var = AddressBook.deploy({"from": account})

   deploy_var.add("fps", "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", {"from": account})

   deploy_var.updateName("fps", "solo", {"from": account})

   _zero_address = "0x0000000000000000000000000000000000000000"
   expected_address = "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"
   fake_address = _zero_address

   with reverts():
      fake_address = deploy_var.getAddress("fps")

   actual_address = deploy_var.getAddress("solo")

   assert fake_address == _zero_address
   assert actual_address == expected_address



def testDelete():
   account = accounts[0]
   
   deploy_var = AddressBook.deploy({"from": account})

   deploy_var.add("fps", "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593", {"from": account})

   deploy_var.updateName("fps", "solo", {"from": account})

   deploy_var.remove("solo", {"from": account})

   _zero_address = "0x0000000000000000000000000000000000000000"
   expected_address = "0x5e078E6b545cF88aBD5BB58d27488eF8BE0D2593"
   fake_address = _zero_address
   actual_address = _zero_address

   with reverts():
      fake_address = deploy_var.getAddress("fps")
      actual_address = deploy_var.getAddress("solo")

   assert fake_address == _zero_address
   assert actual_address != expected_address