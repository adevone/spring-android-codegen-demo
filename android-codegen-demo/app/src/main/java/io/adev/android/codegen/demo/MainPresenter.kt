package io.adev.android.codegen.demo

import client.About
import client.GetAbout
import client.SetAbout
import kotlinx.coroutines.launch
import moxy.InjectViewState
import moxy.MvpView
import moxy.viewstate.strategy.AddToEndSingleStrategy
import moxy.viewstate.strategy.StateStrategyType
import org.kodein.di.erased.instance

interface MainView : MvpView {

    @StateStrategyType(AddToEndSingleStrategy::class)
    fun displayAbout(about: About)
}

@InjectViewState
class MainPresenter : BasePresenter<MainView>() {

    private val getAbout: GetAbout by instance()
    private val setAbout: SetAbout by instance()

    fun onSendClick(title: String, text: String) {
        launch {
            setAbout(body = About(title, text))
        }
    }

    override fun onFirstViewAttach() {
        super.onFirstViewAttach()
        reloadAbout()
    }

    fun onRefreshClick() {
        reloadAbout()
    }

    private fun reloadAbout() {
        launch {
            val about = getAbout().ok()
            viewState.displayAbout(about)
        }
    }
}