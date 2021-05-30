import hashlib

import typing
import enum

from utils import *
from http import HTTPStatus

api_url = 'http://localhost:5000'


def main():
    # create user
    user_list = [
        ['the_1_user', 'password1', 'test1@test.com'],
        ['the_2_user', 'password2', 'test2@test.com'],
        ['the_3_user', 'password3', 'test3@test.com'],
        ['the_4_user', 'password4', 'test4@test.com'],
        ['the_5_user', 'password5', 'test5@test.com'],
        ['第六个用户', 'password6', 'test6@test.com'],
    ]

    print('[*] user_succeed: ', 
        sum(
            [1 if create_user(*user) else 0 
            for user in user_list]
        ), '/', len(user_list), sep='')

    # create company
    company_list = [
        ['the_1_company', 'password_1', 'description'],
        ['the_2_company', 'password_2', 'description'],
        ['the_3_company', 'password_3', 'description'],
        ['the_4_company', 'password_4', 'description'],
        ['the_5_company', 'password_5', 'description'],
        ['the_6_company', 'password_6', 'description'],
        ['第七个公司', 'password_7', '描述'],
    ]

    print('[*] company_succeed: ', 
        sum(
            [1 if create_company(*company) else 0 
            for company in company_list]
        ), '/', len(company_list), sep='')

    # admin: login
    admin_token = login_admin('admin', 'admin')
    if (admin_token == None):
        print("!!![*] admin login failed!")
        return

    # company: create template
    template_list = [
        ['info_title_1', 'this is description for info_title 1'],
        ['信息标题2', '这是信息标题2的描述'],
        ['info_title_3', 'this is description for info_title 3'],
        ['info_title_4', 'this is description for info_title 4'],
        ['信息标题5', '这是信息标题5的描述'],
    ]

    print('[*] template_succeed: ', 
        sum(
            [1 if create_template(template[0], template[1], admin_token) else 0 
            for template in template_list]
        ), '/', len(template_list), sep='')

    

    # admin: get companies
    companies = get_companies(admin_token)
    # print("This is all companies got from admin:", companies)
    if (companies is None):
        return

    # admin: approve companies
    print('[*] approve_company_succeed: ', 
        sum(
            [1 if approve_company(company['company_id'], admin_token) else 0 
            for company in companies]
        ), '/', len(companies), sep='')

    # admin: get tempaltes
    templates = get_templates('waiting', admin_token)
    # print("This is all templates got from admin:", templates)
    if (templates is None):
        return

    # admin: approve template
    print('[*] approve_template_succeed: ', 
        sum(
            [1 if approve_template(template['template_id'], admin_token) else 0 
            for template in templates]
        ), '/', len(templates), sep='')

    # admin: create admin
    cnt = create_admin('admin1', 'admin1', admin_token)
    if (cnt != 1):
        print('!!![*] create admin failed!')
        return

    # user: login
    user_token_list = [ 
        token for token in [
            login_user(user[0], user[1]) 
            for user in user_list]
        if token != None]
    if (len(user_token_list) != len(user_list)):
        print('!!![*] user_login_failed, only', len(user_token_list), 'of', len(user_list), 'passed')
        return
    print('[*] user_login_succeed')

    # user: get templates
    templates = get_templates('approved', user_token_list[0])
    if (templates is None):
        return

    # user: create info
    cnt = sum([
        create_info(template['template_id'], template['title'] + ' for ' + user_list[index][0], user_token)
                for index, user_token in enumerate(user_token_list)
            for template in templates
    ])
    if (cnt != len(user_list) * len(template_list)):
        print('!!![*] create_info_failed, only', cnt, 'of', len(user_list) * len(template_list), 'was created')
        return
    print('[*] create_info_succeed')

    # user: get info
    info_list_list = [
        # TODO
        get_info(user_token)
            for user_token in user_token_list
    ]
    if (sum(map(len, info_list_list)) != len(user_list) * len(template_list)):
        print('!!![*] get_info_failed, only', sum(map(len, info_list_list)), 'of', len(user_list) * len(template_list), 'was got')
        return
    print('[*] get_info_succeed')
    # print('This is all info: ', info_list_list)

    # user: get info detail
    info_detail_list_list = [
        [
            get_info_detail(info['info_id'], user_token)
            for info in info_list_list[index]
        ] for index, user_token in enumerate(user_token_list)
    ]
    cnt = 0
    for infos in info_detail_list_list:
        for info in infos:
            if (info != None):
                cnt += 1

    if (cnt != len(user_list) * len(template_list)):
        print('!!![*] get_info_detail_failed, only', sum(map(len, info_list_list)), 'of', len(user_list) * len(template_list), 'was got')
        return
    print('[*] get_info_detail_succeed')
    # print('This is all info in detail: ', info_detail_list_list)

    # user: modify info
    cnt = sum([
        modify_info(info['info_id'], info['content'] + ' after edited', user_token_list[index])
                for index, info_list in enumerate(info_detail_list_list)
            for info in info_list
    ])
    if (cnt != len(user_list) * len(template_list)):
        print('!!![*] edit_info_failed, only', cnt, 'of', len(user_list) * len(template_list), 'was editd')
        return
    print('[*] edit_info_succeed')

    # user: edit password
    cnt = sum([
        modify_user_pass(user[1], user[1] + '_new', user_token_list[index])
            for index, user in enumerate(user_list)
    ])
    if (cnt != len(user_list)):
        print('!!![*] edit_user_pass_failed, only', cnt, 'of', len(user_list), 'was editd')
        return
    print('[*] edit_user_pass_succed')

    for user in user_list:
        user[1] = user[1] + '_new'

    # user: relogin using new password
    user_token_list = [ 
        token for token in [
            login_user(user[0], user[1]) 
            for user in user_list]
        if token != None]
    if (len(user_token_list) != len(user_list)):
        print('!!![*] user_relogin_failed, only', len(user_token_list), 'of', len(user_list), 'passed')
        return
    print('[*] user_relogin_succeed')

    # user: modify user_info
    # TODO

    # company: login
    company_token_list = [ 
        token for token in [
            login_company(company[0], company[1]) 
            for company in company_list]
        if token != None]
    if (len(company_token_list) != len(company_list)):
        print('!!![*] company_login_failed, only', len(company_token_list), 'of', len(company_list), 'passed')
        return
    print('[*] company_login_succeed')

    # company: edit company_info
    # TODO

    # company: edit password
    cnt = sum([
        modify_company_pass(company[1], company[1] + '_new', company_token_list[index])
            for index, company in enumerate(company_list)
    ])
    if (cnt != len(company_list)):
        print('!!![*] edit_company_pass_failed, only', cnt, 'of', len(company_list), 'was editd')
        return
    print('[*] edit_company_pass_succeed')

    for company in company_list:
        company[1] = company[1] + '_new'

    # company: add requirements
    cnt = sum([
        create_requirement(template['template_id'], 'read', True, company_token)
                for company_token in company_token_list
            for template in templates
    ])
    if (cnt != len(templates) * len(company_token_list)):
        print('!!![*] add_requirement_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] add_requirement_succeed')

    # admin: add doc
    # TODO

    # admin: edit doc

    # admin: remove doc

    # ----------oauth-------------------


    # get oauth key
    cnt = 0
    for company_token in company_token_list:
        dic = get_company_oauth_key(company_token)
        if (dic != None and dic.get('client_id', None) == "" and dic.get('secret_key', None) == ""):
            cnt += 1
    if (cnt != len(company_token_list)):
        print('!!![*] get_company_oauth_key_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] get_company_oauth_key_succeed')

    # regenerate oauth key
    cnt = sum([
        regenerate_oauth_key(company_token)
            for company_token in company_token_list
    ])
    if (cnt != len(company_token_list)):
        print('!!![*] regenerate_oauth_key_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] regenerate_oauth_key_failed_succeed')
    
    # reget oauth key
    oauth_key_list = [
        get_company_oauth_key(company_token)
            for company_token in company_token_list
    ]
    cnt = sum([
        1 if (oauth_key.get('client_id', '') != '' 
            and oauth_key.get('secret_key', '') != '') else 0
            for oauth_key in oauth_key_list
    ])
    if (cnt != len(company_token_list)):
        print('!!![*] reget_oauth_key_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
    print('[*] reget_oauth_key_failed_succeed')

    # # check if has account
    # cnt = sum([
    #     1 if not check_register_status(user_token, oauth_key['client_id']) else 0
    #         for oauth_key in oauth_key_list
    #             for user_token in user_token_list
    # ])
    # if (cnt != len(company_token_list)):
    #     print('!!![*] check_register_status_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
    # print('[*] check_register_status_succeed')

    # third-party register requirements
    requirements_list = [
        get_register_requirements(oauth_key['client_id'], user_token_list[0])
            for oauth_key in oauth_key_list
    ]

    cnt = 0
    for requirements in requirements_list:
        if (requirements['requirements'] != None and requirements['new_account'] == True):
            cnt += 1
    if (cnt != len(company_token_list)):
        print('!!![*] get_register_requirements_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] get_register_requirement_succeed')

    # print(requirements_list[0])
    # third-party register
    third_party_tokens_list = [
        [
            third_party_register(oauth_key['client_id'], requirements_list[index]['requirements'], user_token)
                for user_token in user_token_list
        ] for index, oauth_key in enumerate(oauth_key_list)
    ]
    cnt = 0
    for third_party_tokens in third_party_tokens_list:
        for third_party_token in third_party_tokens:
            if (third_party_token != None \
                and third_party_token['access_token'] != None \
                and third_party_token['refresh_token'] != None):
                cnt += 1
    if (cnt != len(user_list) * len(company_list)):
        print('!!![*] third-party-register_failed, only', cnt , 'of', len(user_list) * len(company_list), 'was got and right')
    print('[*] third-party-register_succeed')

    # print("third_party_token[0][0]", third_party_tokens_list[0][0])

    # check if has account again using requirements api
    new_requirements_list = [
        get_register_requirements(oauth_key['client_id'], user_token_list[0])
            for oauth_key in oauth_key_list
    ]

    cnt = 0
    for requirements in new_requirements_list:
        if (requirements['requirements'] == [] and requirements['new_account'] == False):
            cnt += 1
    if (cnt != len(company_token_list)):
        print('!!![*] reget_register_requirements_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] reget_register_requirement_succeed')

    # thrid-party login
    new_third_party_tokens_list = [
        [third_party_login(oauth_key['client_id'], user_token)
            for user_token in user_token_list]
        for oauth_key in oauth_key_list
    ]
    cnt = 0
    for third_party_tokens in new_third_party_tokens_list:
        for third_party_token in third_party_tokens:
            if (third_party_token != None \
                and third_party_token['access_token'] != None \
                and third_party_token['refresh_token'] != None):
                cnt += 1
    if (cnt != len(user_list) * len(company_list)):
        print('!!![*] third-party-login_failed, only', cnt , 'of', len(user_list) * len(company_list), 'was got and right')
        return
    print('[*] third-party-login_succeed')

    # company: change requirements
    cnt = sum([
        modify_requirement(template['template_id'], 'all', False, company_token)
                for company_token in company_token_list
            for template in templates
    ])
    if (cnt != len(templates) * len(company_token_list)):
        print('!!![*] modify_requirement_failed, only', cnt , 'of', len(templates) * len(company_token_list), 'was got and right')
        return
    print('[*] modify_requirement_succeed')

    # company: delete requirements
    cnt = sum([
        remove_requirement(template['template_id'], company_token)
                for company_token in company_token_list
            for template in templates[:1]
    ])
    if (cnt != len(company_token_list)):
        print('!!![*] del_requirement_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] del_requirement_succeed')

    # check requirements again
    # check if has account again using requirements api
    new_new_requirements_list = [
        get_register_requirements(oauth_key['client_id'], user_token_list[0])
            for oauth_key in oauth_key_list
    ]
    # print('new_new_req: ', new_new_requirements_list[0])

    cnt = 0
    for requirements in new_new_requirements_list:
        if (requirements['requirements'] != None and requirements['requirements'] != []  and requirements['new_account'] == False):
            cnt += 1
    if (cnt != len(company_token_list)):
        print('!!![*] rereget_register_requirements_failed, only', cnt , 'of', len(company_token_list), 'was got and right')
        return
    print('[*] rereget_register_requirement_succeed')

    # TODO might have some problems
    # changed requirements auth (by user) (the same as register?)
    third_party_tokens_list = [
        [
            third_party_register(oauth_key['client_id'], new_new_requirements_list[index]['requirements'], user_token)
                for user_token in user_token_list
        ] for index, oauth_key in enumerate(oauth_key_list)
    ]
    cnt = 0
    for third_party_tokens in third_party_tokens_list:
        for third_party_token in third_party_tokens:
            if (third_party_token != None \
                and third_party_token['access_token'] != None \
                and third_party_token['refresh_token'] != None):
                cnt += 1
    if (cnt != len(user_list) * len(company_list)):
        print('!!![*] accpet_permission_failed, only', cnt , 'of', len(user_list) * len(company_list), 'was got and right')
        return
    print('[*] accpet_permission_succeed')

    # company: get info
    info_list_list_list = [
        [
            [
                get_info_with_oauth(template['template_id'], thrid_party_token, oauth_key['secret_key'])
                    for template in templates[1:]
            ] for thrid_party_token in third_party_tokens_list[index]
        ] for index, oauth_key in enumerate(oauth_key_list)
    ]

    # company: edit info
    cnt = sum([
        modify_info_with_oauth(template['template_id'], info_list_list_list[index1][index2][index3-1] + ' after oauth edit', thrid_party_token, oauth_key['secret_key'])
                for index1, oauth_key in enumerate(oauth_key_list)
            for index2, thrid_party_token in enumerate(third_party_tokens_list[index1])
        for index3, template in enumerate(templates[1:])
    ])
    if (cnt != len(templates[1:]) * len(third_party_tokens_list[0]) * len(oauth_key_list)):
        print('!!![*] modify_info_by_oauth_failed, only', cnt , 'of', len(user_list) * len(company_list), 'was got and right')
        return
    print('[*] modify_info_by_oauth_succeed')

    # refresh token
    new_oauth_token_list = [
        refresh_token(third_party_token)
            for third_party_tokens in third_party_tokens_list
        for third_party_token in third_party_tokens
    ]

if __name__=="__main__":
    main()

