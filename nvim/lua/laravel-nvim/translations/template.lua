return [[
$loader = app('translator')->getLoader();

$items = [];
$foundLocales = [];

$registerTranslation = function ($fullKey, $type, $locale, $value, $file) use (&$items, &$foundLocales) {
    if (!isset($items[$fullKey])) {
        $items[$fullKey] = [
            'key' => $fullKey,
            'type' => $type,
            'values' => [],
            'files' => [],
        ];
    }

    $items[$fullKey]['values'][$locale] = is_string($value) ? $value : json_encode($value);
    $items[$fullKey]['files'][$locale] = str_replace(base_path(DIRECTORY_SEPARATOR), '', $file);
    $foundLocales[$locale] = true;
};

$addPhp = function ($basePath, $namespace = null) use (&$registerTranslation) {
    if (!is_dir($basePath)) {
        return;
    }

    $finder = \Symfony\Component\Finder\Finder::create()
        ->files()
        ->name('*.php')
        ->in($basePath);

    foreach ($finder as $file) {
        $relative = $file->getRelativePathname();
        $segments = explode(DIRECTORY_SEPARATOR, $relative);

        $detectedNamespace = $namespace;

        // Detect published vendor translations: lang/vendor/{package}/{locale}/{group}.php
        if ($detectedNamespace === null && count($segments) >= 4 && $segments[0] === 'vendor') {
            $detectedNamespace = $segments[1];
            array_shift($segments); // vendor
            array_shift($segments); // package
        }

        // The first remaining segment is the locale
        $locale = array_shift($segments);

        if (empty($segments)) {
            continue;
        }

        $group = pathinfo(array_pop($segments), PATHINFO_FILENAME);
        $prefix = $detectedNamespace ? $detectedNamespace . '::' : '';

        try {
            $translations = require $file->getPathname();
        } catch (\Throwable $e) {
            continue;
        }

        if (!is_array($translations)) {
            continue;
        }

        foreach (\Illuminate\Support\Arr::dot($translations) as $key => $value) {
            $fullKey = $prefix . $group . '.' . $key;
            $registerTranslation($fullKey, 'php', $locale, $value, $file->getPathname());
        }
    }
};

$addJson = function ($basePath, $namespace = null) use (&$registerTranslation) {
    if (!is_dir($basePath)) {
        return;
    }

    $finder = \Symfony\Component\Finder\Finder::create()
        ->files()
        ->name('*.json')
        ->in($basePath);

    foreach ($finder as $file) {
        $relative = $file->getRelativePathname();
        $segments = explode(DIRECTORY_SEPARATOR, $relative);

        $detectedNamespace = $namespace;

        // Detect published vendor JSON translations: lang/vendor/{package}/{locale}.json
        if ($detectedNamespace === null && count($segments) >= 3 && $segments[0] === 'vendor') {
            $detectedNamespace = $segments[1];
            array_shift($segments); // vendor
            array_shift($segments); // package
        }

        $locale = pathinfo(array_pop($segments), PATHINFO_FILENAME);
        $prefix = $detectedNamespace ? $detectedNamespace . '::' : '';

        $content = file_get_contents($file->getPathname());
        $translations = json_decode($content, true);

        if (!is_array($translations)) {
            continue;
        }

        foreach ($translations as $key => $value) {
            $fullKey = $prefix . $key;
            $registerTranslation($fullKey, 'json', $locale, $value, $file->getPathname());
        }
    }
};

if (method_exists($loader, 'paths')) {
    foreach ($loader->paths() as $path) {
        $addPhp($path);
        $addJson($path);
    }
}

if (method_exists($loader, 'namespaces')) {
    foreach ($loader->namespaces() as $namespace => $path) {
        $addPhp($path, $namespace);
        $addJson($path, $namespace);
    }
}

$defaultLocale = config('app.locale');
$fallbackLocale = config('app.fallback_locale');

$expectedLocales = array_values(array_unique(array_filter(array_merge(
    [$defaultLocale, $fallbackLocale],
    array_keys($foundLocales)
))));

$result = [
    'meta' => [
        'default_locale' => $defaultLocale,
        'fallback_locale' => $fallbackLocale,
        'expected_locales' => $expectedLocales,
    ],
    'items' => $items,
];

echo json_encode($result);
]]
