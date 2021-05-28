import pytest

@pytest.yield_fixture(scope='session', autouse=True)
def client():
    from app import create_app
    client = create_app()
    ctx = client.test_request_context()
    with ctx:
        yield client


# @pytest.yield_fixture(scope='session', autouse=True)
# @pytest.mark.usefixtures('client')
# def create_schema():
#     from app import db
#     db.create_all()
#     try:
#         yield
#     finally:
#         db.drop_all()


@pytest.yield_fixture(autouse=True)
def rollback(client):
    from app import db
    ctx = client.test_request_context()
    with ctx:
        db.session.begin(subtransactions=True)
        try:
            yield
        finally:
            db.session.rollback()
            db.session.remove()
