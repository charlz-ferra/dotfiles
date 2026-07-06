// ═══════════════════════════════════════════════════════════════════════════
//  Zen / Firefox user.js — «ПАРАНОЯ, НО РАБОЧАЯ»  (charlz-ferra)
//  Приватность по-максимуму БЕЗ ломающего resistFingerprinting.
//  Контекст: за VPN в цензуре → DoH ВЫКЛ (DNS через VPN), WebRTC не палит IP.
//  Откат: удалить этот файл + about:config reset (или Refresh Zen).
//  Применяется при следующем запуске Zen.
// ═══════════════════════════════════════════════════════════════════════════

/* ───── ТЕЛЕМЕТРИЯ И СБОР ДАННЫХ — В НОЛЬ ───── */
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("browser.attribution.enabled", false);
user_pref("messaging-system.rsexperimentloader.enabled", false);

/* ───── КРАШ-РЕПОРТЫ ───── */
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/* ───── БЛОАТ / РЕКЛАМА В UI ───── */
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);

/* ───── ЗАЩИТА ОТ ТРЕКИНГА (strict) ───── */
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
// Полная изоляция cookie по сайтам (Total Cookie Protection)
user_pref("network.cookie.cookieBehavior", 5);
user_pref("privacy.partition.serviceWorkers", true);
user_pref("privacy.partition.network_state.ocsp_cache", true);
// Целевая анти-фингерпринт-защита (FPP) — НЕ ломающий RFP
user_pref("privacy.fingerprintingProtection", true);
user_pref("privacy.fingerprintingProtection.pbmode", true);

/* ───── УТЕЧКИ / REFERRER / BEACON ───── */
user_pref("network.http.referer.XOriginPolicy", 2); // referer только в пределах eTLD+1
user_pref("network.http.referer.XOriginTrimmingPolicy", 2); // кросс-домен — только origin
user_pref("beacon.enabled", false);
user_pref("browser.send_pings", false);
user_pref("network.IDN_show_punycode", true); // анти-фишинг (поддельные домены)
user_pref("geo.enabled", false); // геолокацию выкл (включишь по сайту вручную)

/* ───── WebRTC: НЕ палить реальный IP (КРИТИЧНО под VPN) ───── */
user_pref("media.peerconnection.enabled", true); // звонки работают
user_pref("media.peerconnection.ice.default_address_only", true); // только дефолтный маршрут (VPN), без утечки локального IP
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

/* ───── HTTPS-ONLY ───── */
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

/* ───── DNS / СОЕДИНЕНИЯ (DoH ВЫКЛ — DNS через твой VPN, не через Cloudflare) ───── */
user_pref("network.trr.mode", 5); // 5 = DoH полностью выключен
user_pref("network.prefetch-next", false); // без префетча страниц (трекинг)
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);

/* ───── СКОРОСТЬ / ЖЕЛЕЗО (Wayland + Intel iGPU VA-API: аппаратное декодирование видео) ───── */
user_pref("media.ffmpeg.vaapi.enabled", true); // HW-декод видео через iGPU = меньше CPU/батареи
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("gfx.webrender.all", true); // GPU-композитинг
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("browser.cache.disk.enable", true); // дисковый кеш ВКЛ (скорость; не палит — партиционирован)

/* ───── МЕЛКАЯ ГИГИЕНА (не ломает юзабилити) ───── */
user_pref("browser.urlbar.trimHttps", true);
user_pref("signon.management.page.breach-alerts.enabled", true); // алерты об утёкших паролях
user_pref("browser.safebrowsing.downloads.remote.enabled", false); // не слать файлы в Google
// Safe Browsing (защита от малвари) ОСТАВЛЕН включённым — он приватный (локальные списки).

/* ───── ЧТО НАМЕРЕННО НЕ ТРОНУТО (чтоб «лучший браузер», а не «сломанный») ─────
   • resistFingerprinting — ВЫКЛ (ломает тёмную тему сайтов, letterbox, timezone→UTC).
   • Очистка кук/истории при выходе — НЕ включена (остаёшься залогинен).
   • Поисковые подсказки в урлбаре — оставлены (удобство).
   • dom.event.clipboardevents — оставлен (иначе ломается вставка на части сайтов).
   • Тема UI Zen — наш userChrome.css (chrome/userChrome.css), включён ниже.
*/

/* ═══════════════════════════════════════════════════════════════════════════
 *  REDTEAM / BLOOD — UI Zen (графит + кровь) + UX
 *  userChrome лежит в chrome/userChrome.css. Применяется при перезапуске Zen.
 * ═══════════════════════════════════════════════════════════════════════════ */

// ─── Включить кастомный userChrome.css (КРИТИЧНО для темы) ───
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// ─── Акцент Zen → кроваво-красный ───
user_pref("zen.theme.accent-color", "#d2772e");
user_pref("zen.theme.color-prefs.use-workspace-colors", true);

// ─── РАСКЛАДКОЙ рулит САМ Zen (Settings → Look and Feel: Browser Layout, Vertical Tabs,
//     Compact view). НЕ форсим из user.js — иначе дерётся с твоим GUI-выбором и «ломается».
//     Тут только нейтральное: ───
user_pref("zen.workspaces.enabled", true);
user_pref("zen.workspaces.continue-where-left-off", true);

/* ═══════════════════════════════════════════════════════════════════════════
 *  ПРИВАТНОСТЬ v2 (добавлено 2026-06-09) — без поломок, DoH/RFP остаются как были
 * ═══════════════════════════════════════════════════════════════════════════ */
// Отключить Mozilla "Privacy-Preserving Attribution" (реклама-атрибуция, ВКЛ по умолчанию!)
user_pref("dom.private-attribution.submission.enabled", false);
// Global Privacy Control — юридический сигнал «не продавай мои данные»
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.globalprivacycontrol.functionality.enabled", true);
// Battery API — фингерпринт-вектор, выкл
user_pref("dom.battery.enabled", false);
// Полная изоляция стороннего хранилища (не только куки)
user_pref(
  "privacy.partition.always_partition_third_party_non_cookie_storage",
  true,
);
// Referer по умолчанию для кросс-домена = только origin
user_pref("network.http.referer.defaultPolicy", 2);
user_pref("network.http.referer.defaultPolicy.pbmode", 2);
// Firefox Suggest / спонсорские подсказки урлбара — выкл
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
// WebRTC: не светить локальные хосты (под VPN)
user_pref("media.peerconnection.ice.no_host", true);
// Mozilla фоновые пинги (connectivity/region) — тише
user_pref("network.connectivity-service.enabled", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);
// HTTPS-only и в приватных окнах
user_pref("dom.security.https_only_mode_pbm", true);
// uBlock/расширения работают на ВСЕХ доменах (вкл mozilla.org)
user_pref("extensions.webextensions.restrictedDomains", "");

/* ───── УДОБСТВО (не прячем, восстанавливаем сессию, умный урлбар) ───── */
// Восстанавливать вкладки при запуске
user_pref("browser.startup.page", 3);
user_pref("browser.sessionstore.resume_from_crash", true);
// Контейнер-вкладки (изоляция сайтов = приватность + удобство)
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);
// Умный урлбар: история/закладки/открытые вкладки, без мусор-предложений
user_pref("browser.urlbar.suggest.history", true);
user_pref("browser.urlbar.suggest.bookmarks", true);
user_pref("browser.urlbar.suggest.openpage", true);
user_pref("browser.urlbar.suggest.engines", false);
// Ctrl+Tab по недавним; не закрывать окно с последней вкладкой; подсветка поиска
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("findbar.highlightAll", true);

// Выгрузка вкладок при нехватке RAM (16GB, NVRM OOM-фиксы) — добавлено 2026-06-10
user_pref("browser.tabs.unloadOnLowMemory", true);
