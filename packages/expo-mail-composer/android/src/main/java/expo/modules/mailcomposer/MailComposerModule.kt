package expo.modules.mailcomposer

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import expo.modules.kotlin.Promise
import expo.modules.kotlin.exception.Exceptions
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class MailComposerModule : Module() {
  private val context
    get() = appContext.reactContext ?: throw Exceptions.ReactContextLost()
  private var composerOpened = false
  private var pendingPromise: Promise? = null

  override fun definition() = ModuleDefinition {
    // TODO: Rename the package to 'ExpoMail'
    Name("ExpoMailComposer")

    AsyncFunction<Boolean>("isAvailableAsync") {
      try {
        val intent = Intent(Intent.ACTION_SENDTO).apply { data = Uri.parse(MAILTO_URI) }
        val packageManager = context.packageManager
        val canOpen = packageManager != null && intent.resolveActivity(packageManager) != null

        return@AsyncFunction canOpen
      } catch (e: Exception) {
        throw ResolveActivityException(e)
      }
    }

    Function("getClients") {
      return@Function getAvailableMailClients()
    }

    AsyncFunction("composeAsync") { options: MailComposerOptions, promise: Promise ->
      val intent = Intent(Intent.ACTION_SENDTO).apply { data = Uri.parse(MAILTO_URI) }
      val application = appContext.throwingActivity.application
      val resolveInfo = context.packageManager.queryIntentActivities(intent, 0)

      val mailIntents = resolveInfo.map { info ->
        val mailIntentBuilder = MailIntentBuilder(options)
          .setComponentName(info.activityInfo.packageName, info.activityInfo.name)
          .putRecipients(Intent.EXTRA_EMAIL)
          .putCcRecipients(Intent.EXTRA_CC)
          .putBccRecipients(Intent.EXTRA_BCC)
          .putSubject(Intent.EXTRA_SUBJECT)
          .putBody(Intent.EXTRA_TEXT, options.isHtml == true)
          .putAttachments(Intent.EXTRA_STREAM, application)
        mailIntentBuilder.build()
      }.toMutableList()

      val primaryIntent = mailIntents.removeAt(mailIntents.size - 1)
      val chooser = Intent.createChooser(primaryIntent, null).apply {
        putExtra(Intent.EXTRA_INITIAL_INTENTS, mailIntents.toTypedArray())
        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      }

      pendingPromise = promise
      appContext.throwingActivity.startActivityForResult(chooser, REQUEST_CODE)
      composerOpened = true
    }

    OnActivityResult { _, payload ->
      if (payload.requestCode == REQUEST_CODE && pendingPromise != null) {
        val promise = pendingPromise ?: return@OnActivityResult
        if (composerOpened) {
          composerOpened = false
          promise.resolve(Bundle().apply { putString("status", "sent") })
        }
      }
    }
  }

  // Function to get available mail clients
  private fun getAvailableMailClients(): List<MailClient> {
    val emailIntent = Intent(Intent.ACTION_SENDTO).apply {
      data = Uri.parse(MAILTO_URI)
    }
    val pm = context.packageManager
    val resolveInfoList = pm.queryIntentActivities(emailIntent, 0)

    return resolveInfoList.map { resolveInfo ->
      val packageName = resolveInfo.activityInfo.packageName
      val appInfo = pm.getApplicationInfo(packageName, 0)
      val appName = pm.getApplicationLabel(appInfo).toString()

      MailClient(label = appName, packageName = packageName)
    }
  }

  companion object {
    private const val REQUEST_CODE = 8675
    private const val MAILTO_URI = "mailto:"
  }
}
