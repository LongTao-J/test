package com.example.histudent.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserSms {
    private String phone;//手机号
    private String password;//密码
    private String sms;//短信
}
