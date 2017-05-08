package com.devis.myluaviewapp;

import android.os.Bundle;

import com.taobao.luaview.activity.LuaViewActivity;
import com.taobao.luaview.global.LuaView;

public class MainActivity extends LuaViewActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LuaView luaview = LuaView.create(this);
        luaview.load("main.lua"); //加载 assets下的main.lua
        setContentView(luaview);
    }
}
