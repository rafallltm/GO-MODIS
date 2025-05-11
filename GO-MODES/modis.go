package main // Esta deve ser a primeira linha!

import (
	"bytes"
	"fmt"
	"os/exec"
	"regexp"
	"strconv"
)

// Códigos ANSI para cores
const (
	Reset  = "\033[0m"
	Red    = "\033[31m"
	Green  = "\033[32m"
	Yellow = "\033[33m"
	Blue   = "\033[34m"
)

func formatTemp(tempStr string) string {
	// Converter a temperatura para float
	temp, err := strconv.ParseFloat(tempStr, 64)
	if err != nil {
		return Yellow + "Formato inválido" + Reset
	}

	// Verificar se a temperatura ultrapassa 50°C
	if temp > 50 {
		return Red + fmt.Sprintf("%.1f°C", temp) + Reset
	}

	// Retornar temperatura em verde se estiver abaixo de 50°C
	return Green + fmt.Sprintf("%.1f°C", temp) + Reset
}

func getCPUTemp() string {
	// Executar o comando `sensors`
	cmd := exec.Command("sensors")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return Red + "Erro ao executar o comando sensors" + Reset
	}

	// Procurar pela temperatura da CPU (k10temp-pci-00c3)
	re := regexp.MustCompile(`(?m)Tctl:\s+\+([\d.]+)°C`)
	matches := re.FindStringSubmatch(out.String())
	if len(matches) > 1 {
		return formatTemp(matches[1])
	}

	return Yellow + "Temperatura da CPU não encontrada" + Reset
}

func getGPUTemp() string {
	// Executar o comando `sensors`
	cmd := exec.Command("sensors")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return Red + "Erro ao executar o comando sensors" + Reset
	}

	// Procurar pela temperatura da GPU (amdgpu-pci-0400)
	re := regexp.MustCompile(`(?m)edge:\s+\+([\d.]+)°C`)
	matches := re.FindStringSubmatch(out.String())
	if len(matches) > 1 {
		return formatTemp(matches[1])
	}

	return Yellow + "Temperatura da GPU não encontrada" + Reset
}

func main() {
	// Exibir as temperaturas da CPU e GPU com cores
	fmt.Println("Temperatura da CPU:", getCPUTemp())
	fmt.Println("Temperatura da GPU:", getGPUTemp())
}
