import http
import requests
import hashlib
import typing
from http import HTTPStatus

api_url = 'http://localhost:5000'



def encode_with_nonce_and_timestamp(key_list : typing.List[int]):
    key_list = list(map(str, key_list))
    key_list.sort()
    s = ''.join(key_list)
    h = hashlib.md5(s.encode())
    return h.hexdigest()



def _post(url, data, token = None):
    if (token != None):
        res = requests.post(api_url + url, json = data, headers={"Authorization": "Bearer " + token})
    else:    
        res = requests.post(api_url + url, json = data)
    res.encoding = 'utf-8'

    return res

def _get(url, data, token = None):
    if (token != None):
        res = requests.get(api_url + url, data, headers={"Authorization": "Bearer " + token})
    else:    
        res = requests.get(api_url + url, data)
    res.encoding = 'utf-8'

    return res

def create_user(username, password, email):
    res = _post('/user/register', {
        'username': username,
        'password': password,
        'email': email,
    })

    if (res.status_code == HTTPStatus.CREATED and
        res.json().get('message', None) == "注册成功，请前往登录界面登录"):
        return 1
    
    return 0

def create_company(username, password, description):
    res = _post('/company/register', {
        'username': username,
        'password': password,
        'description':  description,
    })

    if (res.status_code == HTTPStatus.CREATED and
        res.json().get('message', None) == '注册成功，请前往登录界面登录'):
        return 1
    
    return 0

def create_template(title, description, token):
    res = _post('/template/create', {
        'title': title,
        'description': description,
    }, token = token)

    res.json()
    
    if (res.status_code == HTTPStatus.CREATED and
        res.json().get('message', None) == '申请成功，请等待审批'):
        return 1
    
    print(res.json().get('message', ""))
    return 0

def login_admin(username, password):
    res = _post('/admin/login',{
        'username': 'admin',
        'password': 'admin',
    })

    token = res.json().get('token', None)
    if (token != None):
        return token
    
    return None

def get_companies(token):
    res = _get('/company/get',  {
        'status': 'waiting',
    }, token=token)

    companies = res.json().get('companies', None)
    if (companies != None):
        return companies

    print('!!![*] got error from /company/get:', res.json())
    return None

def approve_company(company_id, token):
    res = _post('/company/approve',{
        'company_id': company_id,
        'status': 'approved'
    }, token=token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        return 1

    return 0

def get_templates(status, token):
    res = _get('/template/get',  {
        'status': status,
    }, token=token)

    templates = res.json().get('templates', None)
    if (templates != None):
        return templates

    print('!!![*] got error from /template/get:', res.json())
    return None

def approve_template(template_id, token):
    res = _post('/template/approve',{
        'template_id': template_id,
        'status': 'approved'
    }, token=token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        return 1

    return 0

def create_admin(username, password, token):
    res = _post('/admin/register', {
        'username': username,
        'password': password,
    }, token=token)

    if (res.status_code == HTTPStatus.CREATED and
        res.json().get('message', None) == '注册成功，请前往登录界面登录'):
        return 1
    
    print("! creat_admin failed: ", res.json())
    return 0

def login_user(username, password):
    res = _post('/user/login', {
        'username': username,
        'password': password,
    })
    
    token = res.json().get('token', None)
    if (token != None):
        return token
    
    return None


def create_info(template_id, content, token):
    res = _post('/info/create', {
        'template_id': template_id,
        'content': content,
    }, token=token)

    if (res.status_code == HTTPStatus.CREATED and res.json().get('message', None) == '创建信息成功'):
        return 1

    print("! create info failed: ", res.json())
    
    return 0

def get_info(token, keywords='', filter_method='我的'):
    res = _get('/info/get', {
        'keywords': keywords,
        'filter_method': filter_method
    }, token=token)

    infos = res.json().get('infos', None)
    if (infos != None):
        return infos

    print('!!![*] got error from /info/get:', res.json())
    return None

def get_info_detail(info_id, token):
    res = _get('/info/get_detail', {
        'info_id': info_id,
    }, token=token)

    info = res.json().get('info', None)
    if (info!=None):
        return info

    return None


def modify_info(info_id, content, token):
    res = _post('/info/modify', {
        'info_id': info_id,
        'content': content,
    }, token=token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '修改成功'):
        return 1

    print("modify info failed for info_id: ", info_id, "err: ", res.json())
    return 0

def modify_user_pass(old_pass, new_pass, token):
    res = _post('/user/modify_password', {
        'old_password': old_pass,
        'new_password': new_pass,
    }, token=token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '更改密码成功'):
        return 1

    return 0

def login_company(username, password):
    res = _post('/company/login', {
        'username': username,
        'password': password,
    })
    
    token = res.json().get('token', None)
    if (token != None):
        return token
    
    return None

def modify_company_pass(old_pass, new_pass, token):
    res = _post('/company/modify_password', {
        'old_password': old_pass,
        'new_password': new_pass,
    }, token=token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '更改密码成功'):
        return 1

    return 0

def get_company_oauth_key(token):
    res = _get('/company/get_oauth_key', {}, token=token)

    if (res.status_code != HTTPStatus.OK):
        return None

    return res.json()

def regenerate_oauth_key(token):
    res = _post('/company/regenerate_oauth_key', {}, token=token)

    if (res.status_code == HTTPStatus.OK):
        return 1

    return 0

# def check_register_status(user_token, client_id):
#     res = _get('/account/third_party_check_register', {
#         'client_id': client_id,
#     }, token=user_token)

#     if (res.json().get('message', None) == 'registerd'):
#         return True

#     return False


def get_register_requirements(client_id, user_token):
    res = _get('/account/check_requirements_changes', {
        'client_id': client_id,
    }, token=user_token)

    requirements = res.json().get('requirements', None)
    if (requirements != None):
        return res.json()

    return None

def third_party_register(client_id, req_list, user_token):
    res = _post('/account/third_party_register', {
        'client_id': client_id,
        'approvements': [
            {
                'requirement_id': req['requirement_id'],
                'approvement': True,
            } for index, req in enumerate(req_list)
        ]
    }, token=user_token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        access_token = res.json().get('access_token')
        refresh_token = res.json().get('refresh_token')   
        return {
            'access_token': access_token,
            'refresh_token': refresh_token,
        }
    print('register failed: ', res.json())

    return None

def third_party_login(client_id, user_token):
    res = _post('/account/third_party_login', {
        'client_id': client_id,
    }, token=user_token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        access_token = res.json().get('access_token')
        refresh_token = res.json().get('refresh_token')   
        return {
            'access_token': access_token,
            'refresh_token': refresh_token,
        }

def create_requirement(template_id, permission, optional, company_token):
    res = _post('/requirement/create', {
        'template_id': template_id,
        'permission': permission,
        'optional': optional,
    }, token = company_token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '创建成功'):
        return 1
    
    print("create req failed: ", res.json())
    return 0

def modify_requirement(template_id, permission, optional, company_token):
    res = _post('/requirement/modify', {
        'template_id': template_id,
        'permission': permission,
        'optional': optional,
    }, token = company_token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '修改成功'):
        return 1
    print("edit req failed: ", res.json())
    
    return 0

def remove_requirement(template_id, company_token):
    res = _post('/requirement/remove', {
        'template_id': template_id,
    }, token = company_token)

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == '删除成功'):
        return 1

    print('remove req failed: ', res.json())
    
    return 0

def get_info_with_oauth(template_id, thrid_party_token, secret_key):
    import random
    import time
    random.seed(time.time())
    nonce = str(random.randint(0, 10**9))
    timestamp = str(int(round(time.time())))
    sign = encode_with_nonce_and_timestamp([nonce, timestamp, secret_key])

    res = _post('/oauth/get_info', {
        'nonce': nonce,
        'timestamp': timestamp,
        'sign': sign,
        'template_id': template_id,
    }, token=thrid_party_token['access_token'])

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        return res.json().get('info', None)

    print('get info using oauth failed ', res.json())

    return None

def modify_info_with_oauth(template_id, content, thrid_party_token, secret_key):
    import random
    import time
    random.seed(time.time())
    nonce = str(random.randint(0, 10**9))
    timestamp = int(round(time.time()))
    sign = encode_with_nonce_and_timestamp([nonce, timestamp, secret_key])

    res = _post('/oauth/modify_info', {
        'nonce': nonce,
        'timestamp': timestamp,
        'sign': sign,
        'template_id': template_id,
        'content': content,
    }, token=thrid_party_token['access_token'])

    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        return 1

    return 0

def refresh_token(token):
    res = _post('/oauth/refresh_token', {}, token=token['refresh_token'])
    
    if (res.status_code == HTTPStatus.OK and res.json().get('message', None) == 'succeed'):
        access_token = res.json().get('access_token')
        refresh_token = res.json().get('refresh_token')   
        return {
            'access_token': access_token,
            'refresh_token': refresh_token,
        }
    
    return None
