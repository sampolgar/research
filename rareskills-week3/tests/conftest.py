import pytest


@pytest.fixture
def acct1(accounts):
    return accounts[0]


@pytest.fixture
def verifier_contract(acct1, project):
    return acct1.deploy(project.VERIFIER)

