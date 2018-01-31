elm-app build

docker build -t futurice/tribevibe-front:$(git rev-parse --short HEAD) .
