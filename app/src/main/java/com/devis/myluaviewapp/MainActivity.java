package com.devis.myluaviewapp;

import android.os.Bundle;
import android.widget.Toast;

import com.devis.myluaviewapp.provider.GlideImageProvider;
import com.taobao.luaview.activity.LuaViewActivity;
import com.taobao.luaview.global.LuaView;
import com.taobao.luaview.global.LuaViewConfig;

public class MainActivity extends LuaViewActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LuaView.registerImageProvider(GlideImageProvider.class);
        LuaView luaview = LuaView.create(this);

        luaview.setUseStandardSyntax(true); //开启标准语法
        luaview.load("main.lua"); //加载 assets下的main.lua

        setContentView(luaview);
    }

    @Override
    public void onBackPressed() {
        //屏蔽
        Toast.makeText(this, "啦啦啦，不能返回", Toast.LENGTH_SHORT).show();
//        super.onBackPressed();
    }
}
