package io.adev.android.codegen.demo

import android.util.Log
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import moxy.MvpPresenter
import moxy.MvpView
import kotlin.coroutines.CoroutineContext

abstract class BasePresenter<TView : MvpView> : MvpPresenter<TView>(),
    CoroutineScope,
    AppKodeinAware {

    private val job = SupervisorJob()
    override val coroutineContext: CoroutineContext = job + Dispatchers.Main + CoroutineExceptionHandler { _, e ->
        Log.e("BasePresenter", e.message, e)
    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
    }
}