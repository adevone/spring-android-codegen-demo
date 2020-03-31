package io.adev.android.codegen.demo

import android.os.Bundle
import client.About
import kotlinx.android.synthetic.main.activity_main.*
import moxy.MvpAppCompatActivity
import moxy.ktx.moxyPresenter

class MainActivity : MvpAppCompatActivity(), MainView {

    private val presenter by moxyPresenter { MainPresenter() }

    override fun displayAbout(about: About) {
        titleView.text = about.title
        textView.text = about.text
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        sendButton.setOnClickListener {
            val title = titleEdit.text?.toString() ?: ""
            val text = textEdit.text?.toString() ?: ""
            presenter.onSendClick(title, text)
        }

        refreshButton.setOnClickListener {
            presenter.onRefreshClick()
        }
    }
}
