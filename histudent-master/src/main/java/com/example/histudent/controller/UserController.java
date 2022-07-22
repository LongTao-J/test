package com.example.histudent.controller;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.profile.DefaultProfile;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.example.histudent.pojo.Smss;
import com.example.histudent.pojo.TokenPj;
import com.example.histudent.pojo.User;
import com.example.histudent.pojo.UserSms;
import com.example.histudent.service.UserService;
import com.example.histudent.utils.Consts;
import com.example.histudent.utils.R;
import com.example.histudent.utils.TokenUtil;
import com.google.gson.Gson;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    @CrossOrigin
    public R<TokenPj> login(HttpServletRequest request, @RequestBody User user){

        LambdaQueryWrapper<User> queryWrapper=new LambdaQueryWrapper<>();
        queryWrapper.eq(User::getPhone,user.getPhone());
        User user1=userService.getOne(queryWrapper);//数据库user
        if (user1==null){
            return R.error("登陆失败");
        }

        if (!user1.getPassword().equals(user.getPassword())){
            return R.error("密码错误");
        }

        request.getSession().setAttribute(Consts.SESSION_USER,user1.getId());
        System.out.println("登陆成功");

        //token
        Map<String,Object> m = new HashMap<String,Object>();
        m.put("userid",user1.getId());
        String token= TokenUtil.createJavaWebToken(m);
        TokenPj tokenPj=new TokenPj();
        tokenPj.setToken(token);
        return R.success(tokenPj);
    }

    @PostMapping("/register")//注册
    @CrossOrigin
    public R<String> register(HttpServletRequest requests, @RequestBody UserSms userSms){
        String sms1= (String) requests.getSession().getAttribute(Consts.SESSION_SMS);
        System.out.println("========session："+sms1+"  my"+userSms.getSms());
        if (!userSms.getSms().equals(sms1)){
            return R.error("验证码错误");
        }
        User user=new User();
        user.setPhone(userSms.getPhone());
        user.setPassword(userSms.getPassword());
        userService.save(user);
        return R.success("注册成功");
    }

    //短信发送
    @GetMapping("/sendCode/{phone}")
    @CrossOrigin
    public R<Smss> duanxin(HttpServletRequest requests,@PathVariable String phone){
        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou", "LTAI5tSKh58f7gFHg2qpfw7k", "FgCcfuYtsoTAEgrzg2LfJhbP1ReDy0");
        IAcsClient client = new DefaultAcsClient(profile);
        Random random=new Random();
        Smss smss=new Smss();
        smss.setSms(String.valueOf(random.nextInt(9999-1000+1)+1000));//验证码

        SendSmsRequest request = new SendSmsRequest();
        request.setSignName("阿里云短信测试");
        request.setTemplateCode("SMS_154950909");
        System.out.println("电话号码为："+phone);
        request.setPhoneNumbers(phone);
        request.setTemplateParam("{\"code\":\""+smss.getSms()+"\"}");

        try {
            SendSmsResponse response = client.getAcsResponse(request);
            System.out.println(new Gson().toJson(response));
        } catch (ServerException e) {
            e.printStackTrace();
        } catch (ClientException e) {
            System.out.println("ErrCode:" + e.getErrCode());
            System.out.println("ErrMsg:" + e.getErrMsg());
            System.out.println("RequestId:" + e.getRequestId());
        }
        requests.getSession().setAttribute(Consts.SESSION_SMS,smss.getSms());

        return R.success(smss);
    }

    @PostMapping("/logout")
    @CrossOrigin
    public R<String> logout(HttpServletRequest request){
        //清理Session中保存的当前登录员工的id
        request.getSession().removeAttribute(Consts.SESSION_USER);
        return R.success("退出成功");
    }

}
