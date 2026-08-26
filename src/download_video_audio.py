import subprocess
import time
from playwright.sync_api import sync_playwright


def get_wistia_manifest_urls(page_url: str) -> list[str]:
    found_urls: set[str] = set()

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        def handle_request(request):
            url = request.url
            # Nur die Haupt-Manifest-URLs von Wistia greifen
            if "fast.wistia.com/embed/medias/" in url and url.endswith(".m3u8"):
                found_urls.add(url)

        page.on("request", handle_request)
        page.goto(page_url, timeout=60000, wait_until="domcontentloaded")

        page.evaluate("window.scrollTo(0, document.body.scrollHeight)")
        time.sleep(3)

        browser.close()

    return sorted(list(found_urls))


def download_batch(urls: list[str]):
    for index, url in enumerate(urls, start=1):
        print(f"\n[Download {index}/{len(urls)}] Starte Wistia-Import: {url}")
        # Lädt maximal 720p herunter, spart Speicher und geht noch schneller
        cmd = [
            "yt-dlp",
            "-f",
            "bestvideo[height<=720]+bestaudio/best[height<=720]",
            url,
            "-o",
            f"downloads/media_{index:02d}.%(ext)s",
        ]
        subprocess.run(cmd)


if __name__ == "__main__":
    website = "https://thorsten.live/planb-replay/"
    manifest_urls = get_wistia_manifest_urls(website)

    print(
        f"{len(manifest_urls)} Wistia-Hauptmedien gefunden: {manifest_urls}"
    )
    download_batch(manifest_urls)
