package com.example.histudent.utils;

import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Data
public class R<T>{

    private Integer code;// 1表示成功，0表示失败
    private String msg;// 成功或失败的提示信息
    private T data;//传递的数值

    private Map map=new HashMap<>();

    public static <T> R<T> success(T object){
        R<T> r=new R<T>();
        r.data=object;
        r.code=1;
        return r;
    }

    public static <T> R<T> error(String msg){
        R<T> r=new R<T>();
        r.msg=msg;
        r.code=0;
        return r;
    }

    public R<T> add(String key,Object value){
        this.map.put(key,value);
        return this;
    }
}
