var MetaCoin = artifacts.require("./MetaCoin");

var CREATION_BOUNTY = 10000;
var CREDIT_VALUE = 1000;

contract("New MetaCoin", function (accounts) {
	
	var testing;
	
	it("should exist in passthrough", function () {
		console.log();

		return MetaCoin.new().
			then(function (instance) {
				return instance;
			}).
			then(function (instance) {
				console.log("    - " + instance.address);
				// Exists
				assert.notEqual(instance.address, undefined, "Instance has no address");
				// Isn't blank
				assert.notEqual(instance.address, 0, "Instance address is 0x0");
			});
	});
	it("should exist in meta", function () {
		console.log();
		// Hold onto instance once initialized
		var meta;

		return MetaCoin.new().
			then(function (instance) {
				meta = instance;
			}).
			then(function () {
				console.log("    - " + meta.address);
				// Meta exists
				assert.notEqual(meta.address, undefined, "Meta has no address");
				// Meta ok
				assert.notEqual(meta.address, 0, "Meta has no address");
				// USED IN NEXT TEST
				testing = meta;
			});
	});
	it("should be new contract", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;

		return MetaCoin.new().
			then(function (instance) {
				meta = instance;
			}).
			then(function () {
				console.log("    - " + meta.address);
				// Contract is unique
				assert.notEqual(meta.address, testing.address, "Instance is duplicate");
			});
	});
	it("should not accept balance", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;
		
		// Balance should follow pattern
		return MetaCoin.new().
			then(function (instance) {
				meta = instance;
			}).
			then(function(){
				return web3.eth.getBalance(meta.address);
			}).
			then(function(balance){
				console.log("    - " + meta.address);
				console.log("    - " + balance + " / (" + 0 + ")");
				assert.equal(balance, 0, "Payment acceptance incorrect");
			});
	});
	it("should provide owner with creation bounty", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;
		var account;
		
		// New coin - 1
		account = accounts[1];
		return MetaCoin.new({from:account}).
			then(function (instance) {
				meta = instance;
			}).
			then(function(){
				return meta.getBalance.call(account);
			}).
			then(function(balance){
				console.log("    - " + account);
				console.log("    - " + balance.toNumber() + " / (" + CREATION_BOUNTY + ")");
				assert.equal(balance.toNumber(), CREATION_BOUNTY, "Bounty payment incorrect");
			});
	});
	it("can transfer balances", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;

		// Get initial balances of first and second account.
		var account_one = accounts[0];
		var account_two = accounts[1];

		var account_one__balance;
		var account_two__balance;

		return MetaCoin.new().
		then(function (instance) {
			meta = instance;
			// USED IN NEXT TEST
			testing = meta;
			console.log("    - " + meta.address);
			return meta.sendCoin(account_two, CREDIT_VALUE, {from: account_one});
		}).then(function () {
			return meta.getBalance.call(account_one);
		}).then(function(balance){
			account_one_balance = balance.toNumber();
			return meta.getBalance.call(account_two);
		}).then(function (balance) {
			account_two_balance = balance.toNumber();

			console.log("    - " + account_one_balance);
			console.log("    - " + account_two_balance);
			
			assert.equal(account_one_balance, (CREATION_BOUNTY - CREDIT_VALUE), "Account 1 isn't what is expected");
			assert.equal(account_two_balance, CREDIT_VALUE , "Account 2 isn't what is expected");
		});
	});
	it("keeps balances across tests", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;

		// Get initial balances of first and second account.
		var account_one = accounts[0];
		var account_two = accounts[1];

		var account_one__balance;
		var account_two__balance;

		return MetaCoin.at(testing.address).
		then(function (instance) {
			meta = instance;
			console.log("    - " + meta.address);
			return meta.getBalance.call(account_one);
		}).then(function (balance) {
			account_one_balance = balance.toNumber();
			return meta.getBalance.call(account_two);
		}).then(function (balance) {
			account_two_balance = balance.toNumber();

			console.log("    - " + account_one_balance);
			console.log("    - " + account_two_balance);

			assert.equal(account_two_balance, CREDIT_VALUE , "Account 2 unbalanced");
			assert.equal(account_one_balance, (CREATION_BOUNTY - CREDIT_VALUE), "Account 1 unbalanced");
		});
	});
	it("should have libraries available", function () {
		console.log();

		// Hold onto instance once initialized
		var meta;
		
		// Balance should follow pattern
		return MetaCoin.new().
			then(function (instance) {
				meta = instance;
			}).
			then(function(){
				return meta.getBalanceInEth.call(accounts[0]);
			}).
			then(function(bignum){
				console.log("    - " + meta.address);
				console.log("    - " + bignum.toNumber() + " / (" + (2*CREATION_BOUNTY) + ")");
				assert.equal(bignum.toNumber(), 2*CREATION_BOUNTY, "Library conversion incorrect");
			});
	});
});
