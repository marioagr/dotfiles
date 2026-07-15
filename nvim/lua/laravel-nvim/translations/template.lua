return [[
$loader = app('translator')->getLoader();

$items = [];

$addPhp = function ($basePath, $namespace = null) use (&$items) {
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
        array_shift($segments);

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
            $items[$fullKey] = [
                'key' => $fullKey,
                'type' => 'php',
                'file' => str_replace(base_path(DIRECTORY_SEPARATOR), '', $file->getPathname()),
                'value' => is_string($value) ? $value : json_encode($value),
            ];
        }
    }
};

if (method_exists($loader, 'paths')) {
    foreach ($loader->paths() as $path) {
        $addPhp($path);
    }
}

if (method_exists($loader, 'namespaces')) {
    foreach ($loader->namespaces() as $namespace => $path) {
        $addPhp($path, $namespace);
    }
}

echo json_encode(array_values($items));
]]
